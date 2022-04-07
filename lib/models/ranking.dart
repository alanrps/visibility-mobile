import 'package:json_annotation/json_annotation.dart';

part 'ranking.g.dart';

@JsonSerializable()
class Ranking {
  String? name;
  int? points;
  int? level;

  Ranking({
    required this.name,
    required this.points,
    required this.level,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) =>
      _$RankingFromJson(json);

  Map<String, dynamic> toJson() => _$RankingToJson(this);
}