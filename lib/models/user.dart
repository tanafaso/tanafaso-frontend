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
}
