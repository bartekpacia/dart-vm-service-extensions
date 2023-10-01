A sample command-line application demonstrating Dart VM service extensions.

### Usage

Run `priner` first with Dart VM service enabled (it's disabled by default):

```console
$ dart run --enable-vm-service bin/printer.dart
The Dart VM service is listening on http://127.0.0.1:8181/FmMJoBzneFU=/
The Dart DevTools debugger and profiler is available at: http://127.0.0.1:8181/FmMJoBzneFU=/devtools?uri=ws://127.0.0.1:8181/FmMJoBzneFU=/ws
Count: 0
Registered service extension ext.printer.getCount in isolates/718812529134167
Count: 1
Count: 2
```

Two things are needed from this output: the address of the VM service and the ID
of the main isolate. Then, run `spy` and pass those values to it (replacing
`http` with `ws`):

```console
dart run bin/spy.dart ws://127.0.0.1:8181/FmMJoBzneFU\=/ isolates/718812529134167
Calling service extension ext.printer.getCount...
Got response from ext.printer.getCount: {status: printing, count: 2}
```
