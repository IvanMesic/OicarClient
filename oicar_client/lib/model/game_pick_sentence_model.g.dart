// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_pick_sentence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamePickSentenceDTO _$GamePickSentenceDTOFromJson(Map<String, dynamic> json) =>
    GamePickSentenceDTO(
      id: (json['id'] as num).toInt(),
      language: json['language'] == null
          ? null
          : LanguageDTO.fromJson(json['language'] as Map<String, dynamic>),
      contextImage: json['contextImage'] == null
          ? null
          : ContextImageDTO.fromJson(
              json['contextImage'] as Map<String, dynamic>),
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      answerSentence: json['answerSentence'] as String?,
    );

Map<String, dynamic> _$GamePickSentenceDTOToJson(
        GamePickSentenceDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'contextImage': instance.contextImage,
      'answers': instance.answers,
      'answerSentence': instance.answerSentence,
    };
