import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/user_group.dart';
import 'package:flutter/cupertino.dart';

class User {
  String email;
  String id;
  String username;
  String firstName;
  String lastName;

  User({
    @required this.email,
    @required this.id,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() => {};
}
