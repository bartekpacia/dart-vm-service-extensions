import 'dart:convert';
import 'dart:developer' as developer;

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
  const extensionName = 'ext.printer.getStatus';
  developer.registerExtension(extensionName, _getStatusHandler);
  print('registered extension $extensionName');
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
