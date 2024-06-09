import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import 'main_screen.dart';

class PickSentenceGameScreen extends ConsumerWidget {
  const PickSentenceGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(currentPickSentenceGameProvider);

    if (gameData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Game...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Sentence Game'),
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
              ...gameData.answers.map((answer) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(answer),
                      onTap: () {
                        submitResponse(context, ref, answer);
                      },
                    ),
                  )),
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
    ref
        .read(pickSentenceGameResponseProvider.notifier)
        .submitResponse(context, userInput);
  }

  void exitGame(BuildContext context, WidgetRef ref) {
    ref.read(pickSentenceGameStateNotifierProvider.notifier).resetGame();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainMenuScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
