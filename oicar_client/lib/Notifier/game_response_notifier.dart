import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_providers.dart';
import '../services/game_service.dart';

class GameResponseNotifier extends StateNotifier<AsyncValue<void>> {
  final GameService gameService;
  final Ref ref;

  GameResponseNotifier(this.ref, this.gameService)
      : super(const AsyncValue.loading());

  Future<void> submitResponse(BuildContext context, String response) async {
    state = const AsyncValue.loading();
    try {
      final res = await gameService.postGameResponse(response);
      final statusCode = res.statusCode;
      print('Response status code: $statusCode'); // Debug statement
      if (statusCode == 200) {
        print('Correct answer'); // Debug statement
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          key: Key('correct_answer_snackbar'),
          content: Text('Correct Answer!'),
          backgroundColor: Colors.green,
        ));
        await ref.read(gameStateNotifierProvider.notifier).fetchGame();
      } else if (statusCode == 406) {
        print('Incorrect answer'); // Debug statement
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          key: Key('incorrect_answer_snackbar'),
          content: Text('Incorrect Answer! Try again.'),
          backgroundColor: Colors.red,
        ));
      }
      state = const AsyncValue.data(null);
    } catch (err) {
      print('Error: ${err.toString()}'); // Debug statement
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key('error_snackbar'),
        content: Text('Error submitting response: ${err.toString()}'),
        backgroundColor: Colors.red,
      ));
      state = AsyncValue.error(err, StackTrace.current);
    }
  }
}
