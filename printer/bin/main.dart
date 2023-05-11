import 'dart:convert';
import 'dart:developer' as developer;

// ignore: unused_import
import 'package:vm_service/vm_service.dart' as vm_service;

var printCount = 0; // will be updated by main thread

void main(List<String> arguments) {
  const String extensionName = 'ext.printer.status';
  
  developer.registerExtension(extensionName, _printerStatusHandler);
}

Future<developer.ServiceExtensionResponse> _printerStatusHandler(
  String method,
  Map<String, String> parameters,
) async {
  final Map<String, dynamic> result = {
    'status': 'printing',
    'print_count': printCount,
  };

  return developer.ServiceExtensionResponse.result(jsonEncode(result));
}
