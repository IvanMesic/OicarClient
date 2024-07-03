import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_type.dart';
import '../provider/game_providers.dart';
import '../services/preference_service.dart';
import 'eng_game_confirmation_dialog.dart';

class GameCard extends ConsumerWidget {
  final GameType gameType;
  final String imagePath;
  final String gameTitle;

  const GameCard({
    required this.gameType,
    required this.imagePath,
    required this.gameTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => startGame(context, ref, gameType),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: SizedBox(
            width: double.infinity, // Expand card to full width
            height: 180, // Set total height of the card
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/fallback_image.jpg',
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
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
                      color: Colors.black
                          .withOpacity(0.5), // Background color with opacity
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      gameTitle,
                      style: const TextStyle(
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
        showEndGameConfirmationDialog(context, ref);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a language first!')),
      );
    }
  }

  void showEndGameConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EndGameConfirmationDialog(ref: ref);
      },
    );
  }
}
