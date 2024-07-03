import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_fill_blank_model.dart';
import '../model/game_flash_card_model.dart';
import '../model/game_pick_sentence_model.dart';
import '../model/game_type.dart';
import '../notifier/flash_card_game_response_notifier.dart';
import '../notifier/flash_card_game_state_notifier.dart';
import '../notifier/game_response_notifier.dart';
import '../notifier/game_state_notifier.dart';
import '../notifier/pick_sentence_game_response_notifier.dart';
import '../notifier/pick_sentence_game_state_notifier.dart';
import '../services/game_service.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final gameServiceProvider = Provider<GameService>((ref) {
  return GameService();
});

final gameTypeProvider = StateProvider<GameType>((ref) => GameType.none);

final currentGameProvider = StateProvider<GameFillBlankDTO?>((ref) => null);

final gameStateNotifierProvider =
    StateNotifierProvider<GameStateNotifier, GameFillBlankDTO?>((ref) {
  final gameService = ref.watch(gameServiceProvider);
  return GameStateNotifier(ref, gameService);
});

final currentPickSentenceGameProvider =
    StateProvider<GamePickSentenceDTO?>((ref) => null);

final pickSentenceGameStateNotifierProvider =
    StateNotifierProvider<PickSentenceGameStateNotifier, GamePickSentenceDTO?>(
        (ref) {
  final gameService = ref.watch(gameServiceProvider);
  return PickSentenceGameStateNotifier(ref, gameService);
});

final gameResponseProvider =
    StateNotifierProvider<GameResponseNotifier, AsyncValue<void>>((ref) {
  return GameResponseNotifier(ref, ref.read(gameServiceProvider));
});

final pickSentenceGameResponseProvider =
    StateNotifierProvider<PickSentenceGameResponseNotifier, AsyncValue<void>>(
        (ref) {
  return PickSentenceGameResponseNotifier(ref, ref.read(gameServiceProvider));
});

final flashCardGameStateNotifierProvider =
    StateNotifierProvider<FlashCardGameStateNotifier, GameFlashCardDTO?>((ref) {
  final gameService = ref.watch(gameServiceProvider);
  return FlashCardGameStateNotifier(ref, gameService);
});

final currentFlashCardGameProvider =
    StateProvider<GameFlashCardDTO?>((ref) => null);

final flashCardGameResponseProvider =
    StateNotifierProvider<FlashCardGameResponseNotifier, AsyncValue<void>>(
        (ref) {
  return FlashCardGameResponseNotifier(ref, ref.read(gameServiceProvider));
});
