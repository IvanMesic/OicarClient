import 'package:flutter/material.dart';

class GameTextField extends StatelessWidget {
  final TextEditingController controller;

  const GameTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Type your answer here',
        border: OutlineInputBorder(),
      ),
    );
  }
}
