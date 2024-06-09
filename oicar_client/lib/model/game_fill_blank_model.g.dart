// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_fill_blank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameFillBlankDTO _$GameFillBlankDTOFromJson(Map<String, dynamic> json) =>
    GameFillBlankDTO(
      id: (json['id'] as num).toInt(),
      language: json['language'] == null
          ? null
          : LanguageDTO.fromJson(json['language'] as Map<String, dynamic>),
      contextImage: json['contextImage'] == null
          ? null
          : ContextImageDTO.fromJson(
              json['contextImage'] as Map<String, dynamic>),
      sentence: json['sentence'] as String,
    );

Map<String, dynamic> _$GameFillBlankDTOToJson(GameFillBlankDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'contextImage': instance.contextImage,
      'sentence': instance.sentence,
    };

LanguageDTO _$LanguageDTOFromJson(Map<String, dynamic> json) => LanguageDTO(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$LanguageDTOToJson(LanguageDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ContextImageDTO _$ContextImageDTOFromJson(Map<String, dynamic> json) =>
    ContextImageDTO(
      id: (json['id'] as num).toInt(),
      imagePath: json['imagePath'] as String,
    );

Map<String, dynamic> _$ContextImageDTOToJson(ContextImageDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
    };
