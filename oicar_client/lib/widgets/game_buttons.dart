import 'package:flutter/material.dart';

class GameButtons extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmit;
  final VoidCallback onExit;

  const GameButtons({
    Key? key,
    required this.controller,
    required this.onSubmit,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onSubmit(controller.text);
            }
          },
          child: const Text("Submit"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onExit,
          child: const Text("Exit Game"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
