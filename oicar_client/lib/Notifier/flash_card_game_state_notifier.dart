import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_flash_card_model.dart';
import '../provider/game_providers.dart';
import '../services/game_service.dart';
import '../view/main_screen.dart';

class FlashCardGameStateNotifier extends StateNotifier<GameFlashCardDTO?> {
  final GameService gameService;
  final Ref ref;

  FlashCardGameStateNotifier(this.ref, this.gameService) : super(null);

  Future<void> fetchGame() async {
    try {
      final gameData = await gameService.fetchFlashCardGame();
      ref.read(currentFlashCardGameProvider.notifier).state = gameData;
      ref.read(gameTypeProvider.notifier).state = GameType.flashCard;
    } catch (e) {
      ref.read(currentFlashCardGameProvider.notifier).state = null;
      throw e;
    }
  }

  void resetGame() async {
    await gameService.deleteCurrentFlashCardGame();
    ref.read(currentFlashCardGameProvider.notifier).state = null;
    ref.read(gameTypeProvider.notifier).state = GameType.none;
  }
}
