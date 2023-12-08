import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

class Measuring {
  static late void Function(Pointer<Utf8> name, int identifier) _startMeasuring;
  static late void Function(Pointer<Utf8> name, int identifier) _endMeasuring;
  static late void Function(Pointer<Utf8> name, int identifier) _logEvent;
  static late void Function() _printLogs;

  Measuring() {
    final lib = Platform.isAndroid
        ? DynamicLibrary.open("libmeasuring-lib.so")
        : DynamicLibrary.process();

    _startMeasuring = lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Uint64)>>(
            "startMeasuring")
        .asFunction();

    _endMeasuring = lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Uint64)>>(
            "endMeasuring")
        .asFunction();

    _logEvent = lib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>, Uint64)>>(
            "logEvent")
        .asFunction();

    _printLogs =
        lib.lookup<NativeFunction<Void Function()>>("printLogs").asFunction();
  }

  static startMeasuring(String name, int identifier) {
    _startMeasuring(name.toNativeUtf8(), identifier);
  }

  static endMeasuring(String name, int identifier) {
    _endMeasuring(name.toNativeUtf8(), identifier);
  }

  static logEvent(String name, int value) {
    _logEvent(name.toNativeUtf8(), value);
  }

  static printLogs() {
    _printLogs();
  }
}
