import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final Friend friend;

  FriendWidget({@required this.friend});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            friend.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
