import 'package:flutter/material.dart';

class Friend {
  final String userId;
  final String groupId;
  final String username;
  final String firstName;
  final String lastName;
  final bool pending;

  Friend(
      {@required this.userId,
      @required this.groupId,
      @required this.username,
      @required this.firstName,
      @required this.lastName,
      @required this.pending});
}
