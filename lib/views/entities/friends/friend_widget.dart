import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final Friend friend;
  final State parentState;

  FriendWidget({@required this.friend, @required this.parentState});

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
          // Text(
          //   friend.name,
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          // )
        ],
      ),
    );
  }
}
