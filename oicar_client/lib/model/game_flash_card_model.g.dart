// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_flash_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameFlashCardDTO _$GameFlashCardDTOFromJson(Map<String, dynamic> json) =>
    GameFlashCardDTO(
      text: json['text'] as String,
      answer: json['answer'] as String,
      id: (json['id'] as num).toInt(),
      language: LanguageDTO.fromJson(json['language'] as Map<String, dynamic>),
      contextImage: json['contextImage'] == null
          ? null
          : ContextImageDTO.fromJson(
              json['contextImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameFlashCardDTOToJson(GameFlashCardDTO instance) =>
    <String, dynamic>{
      'text': instance.text,
      'answer': instance.answer,
      'id': instance.id,
      'language': instance.language,
      'contextImage': instance.contextImage,
    };
