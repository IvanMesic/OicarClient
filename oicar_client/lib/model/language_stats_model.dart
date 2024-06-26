import 'package:json_annotation/json_annotation.dart';

part 'language_stats_model.g.dart';

@JsonSerializable()
class LanguageStat {
  final String statName;
  final num score;

  LanguageStat({
    required this.statName,
    required this.score,
  });

  factory LanguageStat.fromJson(Map<String, dynamic> json) =>
      _$LanguageStatFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageStatToJson(this);
}
