import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/friends/all_friends/friend_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllFriendsWidget extends StatefulWidget {
  @override
  _AllFriendsWidgetState createState() => _AllFriendsWidgetState();
}

class _AllFriendsWidgetState extends State<AllFriendsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GetFriendsResponse>(
        future: ServiceProvider.usersService.getFriends(),
        builder:
            (BuildContext context, AsyncSnapshot<GetFriendsResponse> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getFriendsListWidget(snapshot.data.friendship);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Retrieving friends...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }

  Widget getFriendsListWidget(Friendship friendship) {
    if (friendship == null ||
        friendship.friends == null ||
        friendship.friends.isEmpty) {
      return Center(
        child: Text(
          'No friends found.',
          key: Keys.allFriendsWidgetNoFriendsFoundKey,
        ),
      );
    }

    List<Friend> nonPendingFriends =
        friendship.friends.where((friend) => !friend.pending).toList();
    return ListView.builder(
      key: Keys.allFriendsWidgetList,
      itemCount: nonPendingFriends.length,
      itemBuilder: (context, index) {
        return FriendListItemWidget(
          friend: nonPendingFriends[index],
        );
      },
    );
  }
}
