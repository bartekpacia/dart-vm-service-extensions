A sample Flutter application demonstrating Dart VM service extensions.

### Usage

Run the app first:

```console
$ flutter run
Using hardware rendering with device sdk gphone64 arm64. If you notice graphics artifacts, consider enabling software
rendering with "--enable-software-rendering".
Launching lib/main.dart on sdk gphone64 arm64 in debug mode...
Running Gradle task 'assembleDebug'...                             13.5s
✓  Built build/app/outputs/flutter-apk/app-debug.apk.
Installing build/app/outputs/flutter-apk/app-debug.apk...          391ms
I/flutter ( 4482): Registered service extension ext.printer.getCount in isolates/2897856839396087
Syncing files to device sdk gphone64 arm64...                      104ms

Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on sdk gphone64 arm64 is available at: http://127.0.0.1:53166/EMYU73JbR-A=/
The Flutter DevTools debugger and profiler on sdk gphone64 arm64 is available at:
http://127.0.0.1:9101?uri=http://127.0.0.1:53166/EMYU73JbR-A=/
```

Two things are needed from this output: the address of the VM service
(`http://127.0.0.1:53166/EMYU73JbR-A=/`) and the ID of the main isolate
(`isolates/2897856839396087`). Then, run `spy` (from `dart_sample` in this repo)
and pass those values to it (replacing `http` with `ws`):

```console
dart run bin/spy.dart ws://127.0.0.1:53166/EMYU73JbR-A\=/ isolates/2897856839396087
```
