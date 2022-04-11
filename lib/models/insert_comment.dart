import 'package:json_annotation/json_annotation.dart';

part 'insert_comment.g.dart';

@JsonSerializable()
class InsertComment {
  int? userId;
  int? markerId;
  String? description;

  InsertComment({
    required this.userId, 
    required this.markerId, 
    required this.description, 
  });

  factory InsertComment.fromJson(Map<String, dynamic> json) =>
      _$InsertCommentFromJson(json);

  Map<String, dynamic> toJson() => _$InsertCommentToJson(this);
}