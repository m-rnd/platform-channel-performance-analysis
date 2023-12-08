import 'package:flutter/services.dart';

import '../measuring.dart';

class FpsMonitor {
  static late MethodChannel _fpsEventChannel;

  FpsMonitor() {
    _fpsEventChannel = const MethodChannel("FpsEvents");
  }

  static start(String experimentName) {
    _fpsEventChannel.invokeMethod("start", experimentName);
  }

  static log(String experimentName, int value) {
    Measuring.logEvent(experimentName, value);
  }

  static stop() {
    _fpsEventChannel.invokeMethod("stop");
  }
}
