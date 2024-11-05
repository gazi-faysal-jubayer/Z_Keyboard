// lib/keyboard_manager.dart
import 'package:flutter/material.dart';

class KeyboardManager extends ChangeNotifier {
  KeyboardLayout _currentLayout = KeyboardLayout.bangla;
  bool _isShiftEnabled = false;
  bool _isSymbolsEnabled = false;

  KeyboardLayout get currentLayout => _currentLayout;
  bool get isShiftEnabled => _isShiftEnabled;
  bool get isSymbolsEnabled => _isSymbolsEnabled;

  void toggleLayout() {
    _currentLayout = _currentLayout == KeyboardLayout.bangla
        ? KeyboardLayout.english
        : KeyboardLayout.bangla;
    notifyListeners();
  }

  void toggleShift() {
    _isShiftEnabled = !_isShiftEnabled;
    notifyListeners();
  }

  void toggleSymbols() {
    _isSymbolsEnabled = !_isSymbolsEnabled;
    notifyListeners();
  }
}

enum KeyboardLayout { bangla, english }