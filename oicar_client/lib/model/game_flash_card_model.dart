// game_flash_card_model.dart
import 'package:json_annotation/json_annotation.dart';

import 'game_fill_blank_model.dart';

part 'game_flash_card_model.g.dart';

@JsonSerializable()
class GameFlashCardDTO {
  final String text;
  final String answer;
  final int id;
  final LanguageDTO language;
  final ContextImageDTO? contextImage;

  GameFlashCardDTO({
    required this.text,
    required this.answer,
    required this.id,
    required this.language,
    required this.contextImage,
  });

  factory GameFlashCardDTO.fromJson(Map<String, dynamic> json) =>
      _$GameFlashCardDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GameFlashCardDTOToJson(this);
}
