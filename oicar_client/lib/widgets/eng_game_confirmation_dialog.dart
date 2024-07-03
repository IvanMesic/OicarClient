import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_type.dart';
import '../provider/game_providers.dart';

class EndGameConfirmationDialog extends StatelessWidget {
  final WidgetRef ref;

  const EndGameConfirmationDialog({required this.ref, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
