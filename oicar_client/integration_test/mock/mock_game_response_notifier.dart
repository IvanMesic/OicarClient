import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/services/game_service.dart';

class MockGameResponseNotifier extends StateNotifier<AsyncValue<void>> {
  final GameService gameService;
  final Ref ref;

  MockGameResponseNotifier(this.ref, this.gameService)
      : super(const AsyncValue.loading());

  @override
  Future<void> submitResponse(BuildContext context, String response) async {
    state = const AsyncValue.loading();
    try {
      // Simulate a successful response
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        key: Key('correct_answer_snackbar'),
        content: Text('Correct Answer!'),
        backgroundColor: Colors.green,
      ));
      // Simulate fetching the next game
      await Future.delayed(const Duration(seconds: 1)); // Simulate delay
      state = const AsyncValue.data(null);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key('error_snackbar'),
        content: Text('Error submitting response: ${err.toString()}'),
        backgroundColor: Colors.red,
      ));
      state = AsyncValue.error(err, StackTrace.current);
    }
  }
}
