// lib/view/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/view/login.dart';

import '../model/game_fill_blank_model.dart';
import '../model/game_flash_card_model.dart';
import '../model/game_pick_sentence_model.dart';
import '../model/game_type.dart';
import '../provider/game_providers.dart';
import '../services/preference_service.dart';
import '../widgets/game_card.dart';
import '../widgets/language_dialog.dart';
import 'flash_card_game_screen.dart';
import 'game_fill_blank.dart';
import 'game_pick_sentence_screen.dart';
import 'stats_view.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<GameFillBlankDTO?>(currentGameProvider, (_, gameData) {
      if (gameData != null) {
        print('Navigating to GameFillBlankScreen');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => GameFillBlankScreen()));
      }
    });

    ref.listen<GamePickSentenceDTO?>(currentPickSentenceGameProvider,
        (_, gameData) {
      if (gameData != null) {
        print('Navigating to PickSentenceGameScreen');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const PickSentenceGameScreen()));
      }
    });

    ref.listen<GameFlashCardDTO?>(currentFlashCardGameProvider, (_, gameData) {
      if (gameData != null) {
        print('Navigating to FlashCardGameScreen');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const FlashCardGameScreen()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick a game"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => showLanguageDialog(context, ref),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            },
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              final langId = ref.read(languageIdProvider);
              if (langId != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StatsView(langId: langId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please select a language first!')),
                );
              }
            },
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameCard(
                key: Key('fill_blank_game'),
                gameType: GameType.fillBlank,
                imagePath: 'assets/gifs/fill_in_the_blank_preview.gif',
                gameTitle: 'Fill in the blank game',
              ),
              GameCard(
                key: Key('pick_sentence_game'),
                gameType: GameType.pickSentence,
                imagePath: 'assets/gifs/pick_a_sentence_preview.gif',
                gameTitle: 'Pick a sentence game',
              ),
              GameCard(
                key: Key('flash_card_game'),
                gameType: GameType.flashCard,
                imagePath:
                    'https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExanRic21jaHdqMjNzbnFvZXk1aTNoZWVuaWNocnY5YXNpaG1pc2lhdiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o6vXNQiixBMsf4Dra/giphy.webp',
                gameTitle: 'Flash Card game',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
