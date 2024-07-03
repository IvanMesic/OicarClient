import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameButtons extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmit;
  final void Function(BuildContext, WidgetRef) onExit;

  const GameButtons({
    Key? key,
    required this.controller,
    required this.onSubmit,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
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
          ],
        );
      },
    );
  }
}
