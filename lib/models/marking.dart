import 'package:json_annotation/json_annotation.dart';

part 'marking.g.dart';

@JsonSerializable()
class Marking {
  int? marking;
  int? publicEvaluations;
  int? privateEvaluations;
  int? place;
  int? wheelchairParking;

  Marking({
    required this.marking, 
    required this.publicEvaluations, 
    required this.privateEvaluations,
    required this.place,
    required this.wheelchairParking,
  });

  factory Marking.fromJson(Map<String, dynamic> json) =>
      _$MarkingFromJson(json);

  Map<String, dynamic> toJson() => _$MarkingToJson(this);
}