import 'dart:async';
import 'dart:io' as io;

import 'package:vm_service/vm_service.dart' as vm_service;

Future<void> main(List<String> args) async {
  final String webSocketUrl = args[0];
  final String isolateId = args[1];

  final io.WebSocket socket = await io.WebSocket.connect(webSocketUrl);
  final StreamController<dynamic> controller = StreamController<dynamic>();
  final Completer<void> streamClosedCompleter = Completer<void>();
  socket.listen(
    (dynamic data) => controller.add(data),
    onDone: () => streamClosedCompleter.complete(),
  );

  final vm_service.VmService vmService = vm_service.VmService(
    controller.stream,
    socket.add,
    disposeHandler: () => socket.close(),
    streamClosed: streamClosedCompleter.future,
  );

  // VmService is a reference to the VM service that is (possibly) running in a
  // different VM

  final serviceExtensionName = 'ext.printer.getCount';
  print('Calling service extension $serviceExtensionName...');
  final vm_service.Response response = await vmService.callServiceExtension(
    serviceExtensionName,
    isolateId: isolateId,
  );
  print('Got response from $serviceExtensionName: ${response.json}');
  socket.close();
}
