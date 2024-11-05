import 'package:flutter/services.dart';

class IMEService {
  static const platform = MethodChannel('z_keyboard/ime');

  static Future<void> commitText(String text) async {
    try {
      await platform.invokeMethod('commitText', {'text': text});
    } catch (e) {
      print('Error committing text: $e');
    }
  }

  static Future<void> deleteText() async {
    try {
      await platform.invokeMethod('deleteText');
    } catch (e) {
      print('Error deleting text: $e');
    }
  }

  static Future<void> performEnter() async {
    try {
      await platform.invokeMethod('performEnter');
    } catch (e) {
      print('Error performing enter: $e');
    }
  }
}