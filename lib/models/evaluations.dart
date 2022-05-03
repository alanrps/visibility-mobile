import 'package:json_annotation/json_annotation.dart';

part 'evaluations.g.dart';

@JsonSerializable()
class Evaluations {
  int? evaluations;
  int? publicEvaluations;
  int? privateEvaluations;
  int? place;
  int? wheelchairParking;

  Evaluations({
    required this.evaluations, 
    required this.publicEvaluations, 
    required this.privateEvaluations,
    required this.place,
    required this.wheelchairParking,
  });

  factory Evaluations.fromJson(Map<String, dynamic> json) =>
      _$EvaluationsFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluationsToJson(this);
}