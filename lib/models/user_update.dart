import 'package:json_annotation/json_annotation.dart';

part 'user_update.g.dart';

@JsonSerializable()
class UserUpdate {
  String? name;
  String? phoneNumber;
  String? birthDate;
 
  get getName => this.name;

  set setName(String name) => this.name = name;

  get getPhoneNumber => this.phoneNumber;

  set setPhoneNumber(phoneNumber) => this.phoneNumber = phoneNumber;

  get getBirthDate => this.birthDate;

  set setBirthDate(birthDate) => this.birthDate = birthDate;

  UserUpdate({required this.name, required this.phoneNumber, required this.birthDate});

  factory UserUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateToJson(this);
}
