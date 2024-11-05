// lib/custom_keyboard.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ime_service.dart';
import 'keyboard_manager.dart';

class CustomKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const CustomKeyboard({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late KeyboardManager _keyboardManager;
  final List<String> _suggestions = [];

  // Bangla Keyboard Layouts
  static const Map<String, List<List<String>>> banglaLayouts = {
    'main': [
      ['দ', 'ূ', 'ী', 'র', 'ট', 'এ', 'ু', 'ি', 'ও', 'প'],
      ['া', 'স', 'ড', 'ত', 'গ', 'হ', 'জ', 'ক', 'ল'],
      ['্', 'য়', 'শ', 'চ', 'আ', 'ব', 'ন', 'ম'],
      ['123', 'space', 'ড়', 'ঙ', '.', 'return']
    ],
    'shift': [
      ['ধ', 'ঊ', 'ঈ', 'ড়', 'ঠ', 'ঐ', 'উ', 'ই', 'ঔ', 'ফ'],
      ['অ', 'ষ', 'ঢ', 'থ', 'ঘ', 'ঃ', 'ঝ', 'খ', 'ং'],
      ['ঁ', 'য', 'ৎ', 'ছ', 'ঋ', 'ভ', 'ণ', 'ঞ'],
      ['123', 'space', 'ঢ়', 'ঙ', ',', 'return']
    ],
  };

  @override
  void initState() {
    super.initState();
    _keyboardManager = KeyboardManager();
    _keyboardManager.addListener(_onKeyboardStateChanged);
  }

  @override
  void dispose() {
    _keyboardManager.removeListener(_onKeyboardStateChanged);
    _keyboardManager.dispose();
    super.dispose();
  }

  void _onKeyboardStateChanged() {
    setState(() {});
    _updateSuggestions();
  }

  void _updateSuggestions() {
    // Here you would implement your suggestion logic
    // This is a simplified version
    setState(() {
      _suggestions.clear();
      final String text = widget.controller.text;
      if (text.isNotEmpty) {
        // Add your suggestion generation logic here
        _suggestions.addAll(['suggestion1', 'suggestion2', 'suggestion3']);
      }
    });
  }

  Widget _buildKey(String label, {double flex = 1}) {
    return Expanded(
      flex: (flex * 10).round(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          child: InkWell(
            onTap: () => _onKeyTap(label),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onKeyTap(String key) async {
    HapticFeedback.lightImpact();

    switch (key) {
      case 'return':
        await IMEService.performEnter();
        break;
      case 'space':
        await IMEService.commitText(' ');
        break;
      case 'backspace':
        await IMEService.deleteText();
        break;
      case '123':
        _keyboardManager.toggleSymbols();
        break;
      case 'shift':
        _keyboardManager.toggleShift();
        break;
      case 'lang':
        _keyboardManager.toggleLayout();
        break;
      default:
        await IMEService.commitText(key);
    }

    _updateSuggestions();
  }
  Widget _buildSuggestionBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (context, index) => const VerticalDivider(),
        itemBuilder: (context, index) {
          return Center(
            child: TextButton(
              onPressed: () => _onKeyTap(_suggestions[index]),
              child: Text(_suggestions[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLayout = _keyboardManager.isShiftEnabled
        ? banglaLayouts['shift']!
        : banglaLayouts['main']!;

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          _buildSuggestionBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var row in currentLayout)
                  Row(
                    children: row.map((key) {
                      switch (key) {
                        case 'space':
                          return _buildKey(' ', flex: 4);
                        case 'return':
                          return _buildKey('⏎', flex: 1.5);
                        default:
                          return _buildKey(key);
                      }
                    }).toList(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                _buildKey('123', flex: 1.5),
                _buildKey(','),
                _buildKey('lang'),
                _buildKey('space', flex: 4),
                _buildKey('.'),
                _buildKey('⌫', flex: 1.5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}