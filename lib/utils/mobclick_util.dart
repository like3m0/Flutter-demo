import 'package:flutter/services.dart';

void mobclickEvent(String id, {required Map attributes}) {
  const methodChannel = const MethodChannel('minutescience_flutter');
  print("mobClickEvent: $attributes");
  try {
    methodChannel.invokeMethod('mobClickEvent', {
      'id': id,
      'attributes': attributes ?? {},
    });
  } on PlatformException catch (e) {
    print("Failed: '${e.message}'.");
  }
}
