import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/view/login.dart';

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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GameFillBlankScreen()));
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
        title: const Text("Pick a game"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => showLanguageDialog(context, ref),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white, // Icon color
              backgroundColor: Colors.blueAccent, // Button background color
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Perform logout functionality here
              // For example, reset authentication status and navigate to login screen
              // ref.read(authNotifierProvider.notifier).logout(); // Ivan fix here
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginScreen(), // Navigate to register page
              )); // Replace with your login route
            },
            style: IconButton.styleFrom(
              foregroundColor: Colors.white, // Icon color
              backgroundColor: Colors.red, // Button background color
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace the first game button with a card

        Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical spacing between cards
        child:
            GestureDetector(
              onTap: () => startGame(context, ref, GameType.fillBlank),
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust margin as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: SizedBox(
                  width: double.infinity, // Expand card to full width
                  height: 180, // Set total height of the card
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image with top portion shown
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners for image
                        child: Image.asset(
                          'assets/gifs/fill_in_the_blank_preview.gif', // Replace with your GIF path
                          width: double.infinity, // Full width of the card
                          fit: BoxFit.fitWidth, // Fit entire width of the image
                          alignment: Alignment.topCenter, // Show the top portion of the image
                        ),
                      ),
                      // Background and text at the bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), // Background color with opacity
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Fill in the blank game',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ),



      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical spacing between cards
        child:
            GestureDetector(
              onTap: () => startGame(context, ref, GameType.pickSentence),
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust margin as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: SizedBox(
                  width: double.infinity, // Expand card to full width
                  height: 180, // Set total height of the card
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image with top portion shown
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners for image
                        child: Image.asset(
                          'assets/gifs/pick_a_sentence_preview.gif', // Replace with your GIF path
                          width: double.infinity, // Full width of the card
                          fit: BoxFit.fitWidth, // Fit entire width of the image
                          alignment: Alignment.topCenter, // Show the top portion of the image
                        ),
                      ),
                      // Background and text at the bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), // Background color with opacity
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Pick a sentence game',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
