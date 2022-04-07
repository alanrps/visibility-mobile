import 'package:json_annotation/json_annotation.dart';

part 'accessibility.g.dart';

@JsonSerializable()
class Accessibility {
  int? accessiblePlace;
  int? notAccessiblePlace;
  int? partiallyAccessiblePlace;

  Accessibility({
    required this.accessiblePlace,
    required this.notAccessiblePlace,
    required this.partiallyAccessiblePlace,
    });

  factory Accessibility.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityFromJson(json);

  Map<String, dynamic> toJson() => _$AccessibilityToJson(this);
}

