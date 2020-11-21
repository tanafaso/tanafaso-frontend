import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatelessWidget {
  final Friend friend;

  FriendRequestWidget({@required this.friend});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [Text('Username: ${friend.username}')],
      ),
    );
  }
}
