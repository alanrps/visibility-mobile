import 'package:json_annotation/json_annotation.dart';

part 'badges.g.dart';

@JsonSerializable()
class Badges {
  String? description;
  String? category;
  int? actionsAmount;
  bool? acquired;
  int? amount;

  Badges({
    required this.description,
    required this.category,
    required this.actionsAmount,
    required this.acquired,
    required this.amount,
    });

  factory Badges.fromJson(Map<String, dynamic> json) =>
      _$BadgesFromJson(json);

  Map<String, dynamic> toJson() => _$BadgesToJson(this);
}