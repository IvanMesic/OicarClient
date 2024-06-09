// flash_card_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';

class FlashCardGameScreen extends ConsumerStatefulWidget {
  const FlashCardGameScreen({Key? key}) : super(key: key);

  @override
  _FlashCardGameScreenState createState() => _FlashCardGameScreenState();
}

class _FlashCardGameScreenState extends ConsumerState<FlashCardGameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final gameData = ref.watch(currentFlashCardGameProvider);

    if (gameData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flash Card Game'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Card Game'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                gameData.contextImage.imagePath,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type your answer here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    submitResponse(context, ref, _controller.text);
                  }
                },
                child: const Text("Submit"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => exitGame(context, ref),
                child: const Text("Exit Game"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitResponse(BuildContext context, WidgetRef ref, String response) {
    ref
        .read(flashCardGameResponseProvider.notifier)
        .submitResponse(context, response);
  }

  void exitGame(BuildContext context, WidgetRef ref) {
    ref.read(flashCardGameStateNotifierProvider.notifier).resetGame();
    Navigator.of(context).pop();
  }
}
