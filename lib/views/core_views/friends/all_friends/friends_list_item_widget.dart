import 'package:azkar/models/friend.dart';
import 'package:azkar/net/payload/groups/responses/get_group_leaderboard_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/friends/all_friends/friend_screen.dart';
import 'package:flutter/material.dart';

class FriendsListItemWidget extends StatelessWidget {
  final Friend friend;

  FriendsListItemWidget({@required this.friend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        GetGroupLeaderboardResponse response = await ServiceProvider
            .groupsService
            .getGroupLeaderboard(friend.groupId);
        if (response.hasError()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.error.errorMessage),
          ));
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => FriendScreen(
                  friend: friend,
                  userScores: response.userScores,
                )));
      },
      child: Card(
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         '${friend.username}',
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
