import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_pick_sentence_model.dart';
import '../model/game_type.dart';
import '../provider/game_providers.dart';
import '../services/game_service.dart';

class PickSentenceGameStateNotifier
    extends StateNotifier<GamePickSentenceDTO?> {
  final GameService gameService;
  final Ref ref;

  PickSentenceGameStateNotifier(this.ref, this.gameService) : super(null);

  Future<void> fetchGame() async {
    try {
      final gameData = await gameService.fetchPickSentenceGame();
      ref.read(currentPickSentenceGameProvider.notifier).state = gameData;
      ref.read(gameTypeProvider.notifier).state = GameType.pickSentence;
    } catch (e) {
      ref.read(currentPickSentenceGameProvider.notifier).state = null;
      throw e;
    }
  }

  void resetGame() async {
    await gameService.deleteCurrentPickSentenceGame();
    ref.read(currentPickSentenceGameProvider.notifier).state = null;
    ref.read(gameTypeProvider.notifier).state = GameType.none;
  }
}
