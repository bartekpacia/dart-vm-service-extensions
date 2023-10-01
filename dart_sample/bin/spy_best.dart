import 'dart:async';
import 'dart:io' as io;

import 'package:vm_service/vm_service.dart' as vm_service;

/// A modified version of the spy program, which automatically gets the ID of
/// the main isolate.
///
/// Uses the vm_service package.
Future<void> main(List<String> args) async {
  final String webSocketUrl = args[0];

  final io.WebSocket socket = await io.WebSocket.connect(webSocketUrl);
  final StreamController<dynamic> controller = StreamController<dynamic>();
  final Completer<void> streamClosedCompleter = Completer<void>();
  socket.listen(
    (dynamic data) => controller.add(data),
    onDone: () => streamClosedCompleter.complete(),
  );

  // VmService is a reference to the VM service that is (possibly) running in a
  // different VM
  final vm_service.VmService vmService = vm_service.VmService(
    controller.stream,
    socket.add,
    disposeHandler: () => socket.close(),
    streamClosed: streamClosedCompleter.future,
  );

  // Find the ID of the main isolate
  final vm_service.VM vm = await vmService.getVM();
  final isolates = vm.isolates!;
  final String mainIsolateId =
      isolates.where((isolate) => isolate.name == 'main').first.id!;

  print('Main isolate ID: $mainIsolateId');

  final vm_service.Isolate mainIsolate =
      await vmService.getIsolate(mainIsolateId);

  print('Libraries:');
  for (final vm_service.LibraryRef library in mainIsolate.libraries ?? []) {
    print(' > ${library.name}');
  }

  print('Service extensions RPCs:');
  for (final String extensionRPC in mainIsolate.extensionRPCs ?? []) {
    print(' > $extensionRPC');
  }

  final serviceExtensionName = 'ext.printer.getCount';
  print('Calling service extension $serviceExtensionName...');
  final vm_service.Response response = await vmService.callServiceExtension(
    serviceExtensionName,
    isolateId: mainIsolateId,
  );
  print('Got response from $serviceExtensionName: ${response.json}');

  socket.close();
}
