import 'package:json_annotation/json_annotation.dart';

part 'evaluation_types.g.dart';

@JsonSerializable()
class Evaluation {
  int? place;
  int? wheelchairParking;

  Evaluation({
    required this.place,
    required this.wheelchairParking,
    });

  factory Evaluation.fromJson(Map<String, dynamic> json) =>
      _$EvaluationFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluationToJson(this);
}