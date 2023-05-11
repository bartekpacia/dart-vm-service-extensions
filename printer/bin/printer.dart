import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:isolate';

// ignore: unused_import
import 'package:vm_service/vm_service.dart' as vm_service;

var printCount = 0; // will be updated by main thread

void main(List<String> arguments) {
  () async {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      printCount++;
      print('Print count: $printCount');
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
    'print_count': printCount,
  };

  return developer.ServiceExtensionResponse.result(jsonEncode(result));
}
