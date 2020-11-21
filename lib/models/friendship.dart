import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

class Friendship {
  final String id;

  // Must always be the same as the current user's ID.
  final String userId;
  final List<Friend> friends;
  final int createdAt;
  final int modifiedAt;

  Friendship(
      {@required this.id,
      @required this.userId,
      @required this.friends,
      @required this.createdAt,
      @required this.modifiedAt});
}
