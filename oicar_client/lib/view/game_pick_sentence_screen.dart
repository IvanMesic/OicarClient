import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/game_image.dart';
import '../widgets/game_loading.dart';

class PickSentenceGameScreen extends ConsumerWidget {
  const PickSentenceGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(currentPickSentenceGameProvider);

    if (gameData == null) {
      return const GameLoading(title: 'Pick Sentence Game');
    }

    return Scaffold(
      appBar: const GameAppBar(title: 'Pick Sentence Game'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gameData.contextImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GameImage(imagePath: gameData.contextImage!.imagePath),
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
    Navigator.of(context).pop();
  }
}
