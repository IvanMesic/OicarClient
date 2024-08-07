import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/game_buttons.dart';
import '../widgets/game_image.dart';
import '../widgets/game_loading.dart';
import '../widgets/game_text_field.dart';
import 'main_screen.dart';

class GameFillBlankScreen extends ConsumerWidget {
  GameFillBlankScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(currentGameProvider);

    if (gameData == null) {
      return const GameLoading(title: 'Fill in the Blank');
    }

    List<String> parts = gameData.sentence.split('_');
    String beforeBlank = parts[0];
    String afterBlank = (parts.length > 1) ? parts[1] : "";

    return Scaffold(
      appBar: GameAppBar(
        title: 'Fill in the Blank',
        exitGame: exitGame,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure full width
            children: [
              if (gameData.contextImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GameImage(imagePath: gameData.contextImage!.imagePath),
                ),
              const SizedBox(height: 20),
              Text('$beforeBlank _ $afterBlank'),
              GameTextField(
                controller: _controller,
                key: const Key('sentence_field'),
              ),
              const SizedBox(height: 20),
              GameButtons(
                controller: _controller,
                onSubmit: (response) => submitResponse(context, ref, response),
                onExit: (context, ref) => exitGame(context, ref),
                key: const Key('submit_button'),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: false,
                child: ElevatedButton(
                  key: const Key('correct_answer_snackbar'),
                  onPressed: () {
                    print('Hidden button pressed');
                  },
                  child: const Text('Hidden Button'),
                ),
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
