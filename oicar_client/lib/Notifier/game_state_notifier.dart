import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_fill_blank_model.dart';
import '../provider/game_providers.dart';
import '../services/game_service.dart';
import '../view/main_screen.dart';

class GameStateNotifier extends StateNotifier<GameFillBlankDTO?> {
  final GameService gameService;
  final Ref ref;

  GameStateNotifier(this.ref, this.gameService) : super(null);

  Future<void> fetchGame() async {
    try {
      final gameData = await gameService.fetchGamePrompt();
      ref.read(currentGameProvider.notifier).state = gameData;
      ref.read(gameTypeProvider.notifier).state = GameType.fillBlank;
    } catch (e) {
      ref.read(currentGameProvider.notifier).state = null;
      throw e;
    }
  }

  void resetGame() async {
    await gameService.deleteCurrentFillBlankGame();
    ref.read(currentGameProvider.notifier).state = null;
    ref.read(gameTypeProvider.notifier).state = GameType.none;
  }
}
