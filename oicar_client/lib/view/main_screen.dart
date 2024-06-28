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
import 'stats_view.dart'; // Import the StatsView

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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PickSentenceGameScreen()));
      }
    });

    ref.listen<GameFlashCardDTO?>(currentFlashCardGameProvider, (_, gameData) {
      if (gameData != null) {
        Navigator.push(
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
              foregroundColor: Colors.white, // Icon color
              backgroundColor: Colors.blueAccent, // Button background color
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const LoginScreen(), // Navigate to login screen
              ));
            },
            style: IconButton.styleFrom(
              foregroundColor: Colors.white, // Icon color
              backgroundColor: Colors.red, // Button background color
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart), // Icon can be changed to profile or statistics icon
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
                  const SnackBar(content: Text('Please select a language first!')),
                );
              }
            },
            style: IconButton.styleFrom(
              foregroundColor: Colors.white, // Icon color
              backgroundColor: Colors.green, // Button background color
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () => startGame(context, ref, GameType.fillBlank),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: SizedBox(
                    width: double.infinity, // Expand card to full width
                    height: 180, // Set total height of the card
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/gifs/fill_in_the_blank_preview.gif', // Replace with your GIF path
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment
                                .topCenter, // Show the top portion of the image
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // Background color with opacity
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: const Text(
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () => startGame(context, ref, GameType.pickSentence),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: SizedBox(
                    width: double.infinity, // Expand card to full width
                    height: 180, // Set total height of the card
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/gifs/pick_a_sentence_preview.gif', // Replace with your GIF path
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment
                                .topCenter, // Show the top portion of the image
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // Background color with opacity
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: const Text(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () => startGame(context, ref, GameType.flashCard),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: SizedBox(
                    width: double.infinity, // Expand card to full width
                    height: 180, // Set total height of the card
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExanRic21jaHdqMjNzbnFvZXk1aTNoZWVuaWNocnY5YXNpaG1pc2lhdiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o6vXNQiixBMsf4Dra/giphy.webp', // URL of the GIF
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // Background color with opacity
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Flash Card game',
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
        _showEndGameConfirmationDialog(context, ref);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a language first!')),
      );
    }
  }

  void _showEndGameConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'In order to start a new game you need to end the already started one, are you sure you want to do that?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteGame(ref);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteGame(WidgetRef ref) async {
    final gameService = ref.read(gameServiceProvider);

    try {
      await gameService.deleteCurrentFillBlankGame();
    } catch (e) {}

    try {
      await gameService.deleteCurrentPickSentenceGame();
    } catch (e) {}

    try {
      await gameService.deleteCurrentFlashCardGame();
    } catch (e) {}

    ref.read(gameTypeProvider.notifier).state = GameType.none;
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
