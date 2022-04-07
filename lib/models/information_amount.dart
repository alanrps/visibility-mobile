import 'package:json_annotation/json_annotation.dart';

part 'information_amount.g.dart';

@JsonSerializable()
class InformationAmount {
  int? evaluations;
  int? publicEvaluations;
  int? privateEvaluations;
  int? place;
  int? wheelchairParking;

  InformationAmount({
    required this.evaluations, 
    required this.publicEvaluations, 
    required this.privateEvaluations,
    required this.place,
    required this.wheelchairParking,
  });

  factory InformationAmount.fromJson(Map<String, dynamic> json) =>
      _$InformationAmountFromJson(json);

  Map<String, dynamic> toJson() => _$InformationAmountToJson(this);
}