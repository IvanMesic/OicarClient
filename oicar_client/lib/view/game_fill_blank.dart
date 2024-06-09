import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import 'main_screen.dart';

class GameScreen extends ConsumerWidget {
  GameScreen({Key? key}) : super(key: key);

  // Initialize TextEditingController to capture user input
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to game data changes
    final gameData = ref.watch(currentGameProvider);

    if (gameData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Game...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Components to handle the split parts of the game sentence
    List<String> parts = gameData.sentence.split('_');
    String beforeBlank = parts[0];
    String afterBlank = (parts.length > 1) ? parts[1] : "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill in the Blank',
            style:
                TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gameData.contextImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    gameData.contextImage!.imagePath,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/fallback_image.jpg');
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Text('$beforeBlank _ $afterBlank'),
              TextField(
                controller: _controller, // Use the TextEditingController here
                decoration: const InputDecoration(
                  hintText: 'Type here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Pass the actual input from the TextField
                  if (_controller.text.isNotEmpty) {
                    submitResponse(context, ref, _controller.text);
                  }
                },
                child: const Text("Submit"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => exitGame(context, ref),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Exit Game"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitResponse(BuildContext context, WidgetRef ref, String userInput) {
    final gameData = ref.read(currentGameProvider);
    if (gameData != null) {
      String fullSentence =
          '${gameData.sentence.split('_')[0]}$userInput${gameData.sentence.split('_').length > 1 ? gameData.sentence.split('_')[1] : ""}';
      ref
          .read(gameResponseProvider.notifier)
          .submitResponse(context, fullSentence);
    }
  }

  void exitGame(BuildContext context, WidgetRef ref) {
    ref.read(gameStateNotifierProvider.notifier).resetGame();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainMenuScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
