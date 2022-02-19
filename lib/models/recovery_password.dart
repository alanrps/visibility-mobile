import 'package:json_annotation/json_annotation.dart';

part 'recovery_password.g.dart';

@JsonSerializable()
class RecoveryPassword{
  String email;

  RecoveryPassword({required this.email});

  factory RecoveryPassword.fromJson(Map<String, dynamic> json) => _$RecoveryPasswordFromJson(json);

   Map<String, dynamic> toJson() => _$RecoveryPasswordToJson(this);
}