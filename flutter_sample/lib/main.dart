import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  Future<developer.ServiceExtensionResponse> _getCountHandler(
    String method,
    Map<String, String> parameters,
  ) async {
    final Map<String, dynamic> result = {'count': _count};

    return developer.ServiceExtensionResponse.result(jsonEncode(result));
  }

  @override
  void initState() {
    super.initState();
    if (!kReleaseMode) {
      const String extensionName = 'ext.printer.getCount';
      developer.registerExtension(extensionName, _getCountHandler);
      final String isolateId = developer.Service.getIsolateID(Isolate.current)!;
      print('Registered service extension $extensionName in $isolateId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_count',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
