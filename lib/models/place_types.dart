import 'package:json_annotation/json_annotation.dart';

part 'place_types.g.dart';

@JsonSerializable()
class PlaceTypes {
  int? publicEvaluations;
  int? privateEvaluations;

  PlaceTypes({
    required this.publicEvaluations,
    required this.privateEvaluations,
    });

  factory PlaceTypes.fromJson(Map<String, dynamic> json) =>
      _$PlaceTypesFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceTypesToJson(this);
}