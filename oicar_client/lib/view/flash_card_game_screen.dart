import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/game_buttons.dart';
import '../widgets/game_image.dart';
import '../widgets/game_loading.dart';
import '../widgets/game_text_field.dart';
import 'main_screen.dart';

class FlashCardGameScreen extends ConsumerStatefulWidget {
  const FlashCardGameScreen({Key? key}) : super(key: key);

  @override
  _FlashCardGameScreenState createState() => _FlashCardGameScreenState();
}

class _FlashCardGameScreenState extends ConsumerState<FlashCardGameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final gameData = ref.watch(flashCardGameStateNotifierProvider);

    if (gameData == null) {
      return const GameLoading(title: 'Flash Card Game');
    }

    return Scaffold(
      appBar: GameAppBar(
        title: 'Flash Card Game',
        exitGame: exitGame,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gameData.contextImage != null)
                GameImage(imagePath: gameData.contextImage!.imagePath),
              const SizedBox(height: 20),
              GameTextField(
                controller: _controller,
                key: const Key('response_field'), // Add this key
              ),
              const SizedBox(height: 20),
              GameButtons(
                controller: _controller,
                onSubmit: (response) => submitResponse(context, ref, response),
                onExit: (context, ref) => exitGame(context, ref),
                key: const Key('submit_button'),
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainMenuScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
