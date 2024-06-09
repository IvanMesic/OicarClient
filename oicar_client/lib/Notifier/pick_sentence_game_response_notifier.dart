import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import '../services/game_service.dart';

class PickSentenceGameResponseNotifier extends StateNotifier<AsyncValue<void>> {
  final GameService gameService;
  final Ref ref;

  PickSentenceGameResponseNotifier(this.ref, this.gameService)
      : super(const AsyncValue.loading());

  Future<void> submitResponse(BuildContext context, String fullSentence) async {
    state = const AsyncValue.loading();
    try {
      final response = await gameService.postPickSentenceResponse(fullSentence);
      final statusCode = response.statusCode;
      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Correct Answer!'),
          backgroundColor: Colors.green,
        ));
        await ref
            .read(pickSentenceGameStateNotifierProvider.notifier)
            .fetchGame();
      } else if (statusCode == 406) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Incorrect Answer! Try again.'),
          backgroundColor: Colors.red,
        ));
      }
      state = const AsyncValue.data(null);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error submitting response: ${err.toString()}'),
        backgroundColor: Colors.red,
      ));
      state = AsyncValue.error(err, StackTrace.current);
    }
  }
}
