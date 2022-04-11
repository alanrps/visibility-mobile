import 'package:json_annotation/json_annotation.dart';

part 'get_comments.g.dart';

@JsonSerializable()
class GetComments {
  String? message;
  String? name;

  GetComments({
    required this.message, 
    required this.name, 
  });

  factory GetComments.fromJson(Map<String, dynamic> json) =>
      _$GetCommentsFromJson(json);

  Map<String, dynamic> toJson() => _$GetCommentsToJson(this);
}