import 'package:azkar/main.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:flutter/material.dart';

class SelectFriendScreen extends StatelessWidget {
  final Friendship friendship;

  SelectFriendScreen({@required this.friendship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectAFriend),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildWidgetWithFriends(context, friendship?.friends ?? []),
      ),
    );
  }

  Widget buildWidgetWithFriends(BuildContext context, List<Friend> friends) {
    if (friends?.isEmpty ?? false) {
      return Center(
        child: Text(AppLocalizations.of(context).youHaveNotAddedAnyFriendsYet),
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      padding: EdgeInsets.only(bottom: 8),
      itemBuilder: (context, index) {
        return getFriendCard(context, friends[index]);
      },
    );
  }

  Widget getFriendCard(BuildContext context, Friend friend) {
    return Container(
      child: GestureDetector(
        onTap: () => Navigator.pop(context, friend),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                  VerticalDivider(
                    width: 3,
                    color: Colors.black,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              friend.firstName + " " + friend.lastName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 8)),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              friend.username,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
