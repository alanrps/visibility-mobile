import 'package:flutter/material.dart';

enum Gender { male, female, outro }

class User {
  final String name;
  final Gender gender;
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
}