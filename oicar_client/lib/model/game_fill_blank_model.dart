import 'package:json_annotation/json_annotation.dart';

part 'game_fill_blank_model.g.dart'; // This file is generated by json_serializable

@JsonSerializable()
class GameFillBlankDTO {
  final int id;
  final LanguageDTO? language;
  final ContextImageDTO? contextImage;
  final String sentence;

  GameFillBlankDTO({
    required this.id,
    this.language,
    this.contextImage,
    required this.sentence,
  });

  factory GameFillBlankDTO.fromJson(Map<String, dynamic> json) =>
      _$GameFillBlankDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GameFillBlankDTOToJson(this);
}

@JsonSerializable()
class LanguageDTO {
  final int id;
  final String name;

  LanguageDTO({required this.id, required this.name});

  factory LanguageDTO.fromJson(Map<String, dynamic> json) =>
      _$LanguageDTOFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageDTOToJson(this);
}

@JsonSerializable()
class ContextImageDTO {
  final int id;
  final String imagePath;

  ContextImageDTO({required this.id, required this.imagePath});

  factory ContextImageDTO.fromJson(Map<String, dynamic> json) =>
      _$ContextImageDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ContextImageDTOToJson(this);
}
