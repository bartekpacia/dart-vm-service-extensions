import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

/// A basic version of the spy program, which calls a service extension.
///
/// Depends only on the built-in libraries. In particular, it doesn't depend on
/// the vm_service package.
Future<void> main(List<String> args) async {
  final String webSocketUrl = args[0];
  final String isolateId = args[1];

  final io.WebSocket socket = await io.WebSocket.connect(webSocketUrl);

  socket.listen(
    (dynamic data) {
      var encoder = JsonEncoder.withIndent("  ");
      final response = encoder.convert(jsonDecode(data));

      print('Got response:\n$response');
    },
  );

  socket.add(jsonEncode({
    'jsonrpc': '2.0',
    'id': 1,
    'method': 'getVM',
  }));

  socket.add(jsonEncode({
    'jsonrpc': '2.0',
    'id': 2,
    'method': 'ext.printer.getCount',
    'params': {'isolateId': isolateId},
  }));

  await Future.delayed(Duration(seconds: 10));

  socket.close();
}
