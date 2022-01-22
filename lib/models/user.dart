import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

// part 'user.g.dart';

enum Gender { MALE, FEMALE, OTHER }

@JsonSerializable()
class User {
  final String name;
  final String gender;
  final String birthDate;
  final String phone;
  final String email;
  final String password;

  const User({
    @required this.name,
    @required this.gender,
    @required this.birthDate,
    @required this.phone,
    @required this.email,
    @required this.password,
  });

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  //  Map<String, dynamic> toJson() => _$UserToJson(this);
}