import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:isolate';

var count = 0;

void main() {
  () async {
    while (true) {
      print('Count: $count');
      count++;
      await Future.delayed(Duration(seconds: 1));
    }
  }();
  const String extensionName = 'ext.printer.getStatus';
  developer.registerExtension(extensionName, _getStatusHandler);

  // To call the service extension running in a foreign Dart VM, we need:
  //  * The WebSocket URL of the VM service
  //  * isolate ID of the isolate that is running the service extension
  //  * name of the service extension

  final String isolateId = developer.Service.getIsolateID(Isolate.current)!;
  print('Registered service extension $extensionName in $isolateId');
}

Future<developer.ServiceExtensionResponse> _getStatusHandler(
  String method,
  Map<String, String> parameters,
) async {
  final Map<String, dynamic> result = {
    'status': 'printing',
    'count': count,
  };

  return developer.ServiceExtensionResponse.result(jsonEncode(result));
}
