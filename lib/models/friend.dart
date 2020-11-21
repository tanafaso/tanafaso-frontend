import 'package:flutter/material.dart';

class Friend {
  final String userId;
  final String username;
  final String name;
  final bool pending;

  Friend(
      {@required this.userId,
      @required this.username,
      @required this.name,
      @required this.pending});
}
