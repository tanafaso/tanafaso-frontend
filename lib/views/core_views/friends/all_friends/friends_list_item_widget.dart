import 'package:azkar/models/friend.dart';
import 'package:azkar/views/core_views/friends/all_friends/friend_screen.dart';
import 'package:flutter/material.dart';

class FriendsListItemWidget extends StatelessWidget {
  final Friend friend;

  FriendsListItemWidget({@required this.friend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => FriendScreen(
                  friend: friend,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4.0),
        child: Card(
          margin: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${friend.firstName} ${friend.lastName}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
