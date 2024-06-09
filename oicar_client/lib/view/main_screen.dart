// main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_fill_blank_model.dart';
import '../model/game_flash_card_model.dart';
import '../model/game_pick_sentence_model.dart';
import '../provider/game_providers.dart';
import '../services/language_service.dart';
import '../services/preference_service.dart';
import 'flash_card_game_screen.dart';
import 'game_fill_blank.dart';
import 'game_pick_sentence_screen.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<GameFillBlankDTO?>(currentGameProvider, (_, gameData) {
      if (gameData != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GameScreen()));
      }
    });

    ref.listen<GamePickSentenceDTO?>(currentPickSentenceGameProvider,
        (_, gameData) {
      if (gameData != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PickSentenceGameScreen()));
      }
    });

    ref.listen<GameFlashCardDTO?>(currentFlashCardGameProvider, (_, gameData) {
      if (gameData != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FlashCardGameScreen()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => showLanguageDialog(context, ref),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => startGame(context, ref, GameType.fillBlank),
              child: const Text('Fill Blank Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => startGame(context, ref, GameType.pickSentence),
              child: const Text('Pick Sentence Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => startGame(context, ref, GameType.flashCard),
              child: const Text('Flash Card Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => deleteGame(context, ref),
              child: const Text("End Game"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startGame(
      BuildContext context, WidgetRef ref, GameType gameType) async {
    final language = ref.read(languageIdProvider);
    print("Starting Game, Language: $language");
    if (language != null) {
      try {
        if (gameType == GameType.fillBlank) {
          await ref.read(gameStateNotifierProvider.notifier).fetchGame();
        } else if (gameType == GameType.pickSentence) {
          await ref
              .read(pickSentenceGameStateNotifierProvider.notifier)
              .fetchGame();
        } else {
          await ref
              .read(flashCardGameStateNotifierProvider.notifier)
              .fetchGame();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You\'re already playing a game, please end it before starting a new one!')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No language selected')));
    }
  }

  Future<void> deleteGame(BuildContext context, WidgetRef ref) async {
    final gameService = ref.read(gameServiceProvider);

    try {
      await gameService.deleteCurrentFillBlankGame();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to end Fill Blank game')),
      );
    }

    try {
      await gameService.deleteCurrentPickSentenceGame();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to end Pick Sentence game:')),
      );
    }

    try {
      await gameService.deleteCurrentFlashCardGame();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to end Flash Card game:')),
      );
    }

    ref.read(gameTypeProvider.notifier).state = GameType.none;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game ended successfully')),
    );
  }

  void showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Consumer(
            builder: (context, ref, child) {
              final languagesAsyncValue = ref.watch(languageListProvider);
              return languagesAsyncValue.when(
                data: (languages) => SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final language = languages[index];
                      return ListTile(
                        title: Text(language.name),
                        onTap: () {
                          ref
                              .read(languageIdProvider.notifier)
                              .selectLanguage(language.id);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, stack) => Text('Failed to load languages: $e'),
              );
            },
          ),
        );
      },
    );
  }
}

enum GameType { none, fillBlank, pickSentence, flashCard }
