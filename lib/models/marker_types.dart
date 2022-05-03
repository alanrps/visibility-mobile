import 'package:json_annotation/json_annotation.dart';

part 'marker_types.g.dart';

@JsonSerializable()
class MarkerTypes {
  int? place;
  int? wheelchairParking;

  MarkerTypes({
    required this.place,
    required this.wheelchairParking,
    });

  factory MarkerTypes.fromJson(Map<String, dynamic> json) =>
      _$MarkerTypesFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerTypesToJson(this);
}