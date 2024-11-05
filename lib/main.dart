import 'package:flutter/material.dart';

import 'custom_keyboard.dart';

// lib/main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const KeyboardScreen(),
    );
  }
}

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({Key? key}) : super(key: key);

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বাংলা কীবোর্ড')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'টাইপ করুন...',
                ),
                maxLines: null,
              ),
            ),
          ),
          CustomKeyboard(
            controller: _controller,
            focusNode: _focusNode,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}