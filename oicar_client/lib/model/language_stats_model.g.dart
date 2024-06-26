// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageStat _$LanguageStatFromJson(Map<String, dynamic> json) => LanguageStat(
      statName: json['statName'] as String,
      score: json['score'] as num,
    );

Map<String, dynamic> _$LanguageStatToJson(LanguageStat instance) =>
    <String, dynamic>{
      'statName': instance.statName,
      'score': instance.score,
    };
