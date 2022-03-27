import 'package:json_annotation/json_annotation.dart';

part 'badges.g.dart';

@JsonSerializable()
class Badges {
  int? id;
  int? points;
  String? description;

  Badges({required this.id, required this.points, required this.description});

  factory Badges.fromJson(Map<String, dynamic> json) =>
      _$BadgesFromJson(json);

  Map<String, dynamic> toJson() => _$BadgesToJson(this);
}