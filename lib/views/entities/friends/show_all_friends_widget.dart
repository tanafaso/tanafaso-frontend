import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/entities/friends/friend_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowAllFriendsWidget extends StatefulWidget {
  @override
  _ShowAllFriendsWidgetState createState() => _ShowAllFriendsWidgetState();
}

class _ShowAllFriendsWidgetState extends State<ShowAllFriendsWidget> {
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
    List<Friend> nonPendingFriends =
        friendship.friends.where((friend) => !friend.pending).toList();
    return ListView.builder(
      itemCount: nonPendingFriends.length,
      itemBuilder: (context, index) {
        return FriendWidget(
          friend: nonPendingFriends[index],
        );
      },
    );
  }
}
