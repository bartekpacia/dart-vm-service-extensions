import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

/// A basic version of the spy program, which calls a service extension.
///
///  * Does not depend on the vm_service package.
///  * Must be explicitly provided with the remote VM's main isolate ID.
Future<void> main(List<String> args) async {
  final String webSocketUrl = args[0];
  final String isolateId = args[1];

  final io.WebSocket socket = await io.WebSocket.connect(webSocketUrl);

  socket.listen(
    (dynamic data) {
      var encoder = JsonEncoder.withIndent("  ");
      final response = encoder.convert(jsonDecode(data));

      print('Got response from ext.printer.getCount:\n$response');
    },
  );

  print("Calling service extension ext.printer.getCount...");
  socket.add(jsonEncode({
    'jsonrpc': '2.0',
    'id': 2,
    'method': 'ext.printer.getCount',
    'params': {'isolateId': isolateId},
  }));

  // Simply, hacky way to keep running until the response is received.
  await Future.delayed(const Duration(seconds: 1));

  socket.close();
}
