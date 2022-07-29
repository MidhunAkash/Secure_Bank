
import 'dart:async';

import 'package:flutter/services.dart';

class NativeAdd {
  static const MethodChannel _channel =
      const MethodChannel('native_add');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
