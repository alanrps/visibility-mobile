import 'package:json_annotation/json_annotation.dart';

part 'update_password.g.dart';

@JsonSerializable()
class UpdatePassword{
  String currentPassword;
  String newPassword;

  UpdatePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  factory UpdatePassword.fromJson(Map<String, dynamic> json) => _$UpdatePasswordFromJson(json);

   Map<String, dynamic> toJson() => _$UpdatePasswordToJson(this);
}