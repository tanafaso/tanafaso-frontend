import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/users_service.dart';
import 'package:azkar/views/entities/friends/friend_request_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowFriendRequestsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GetFriendsResponse>(
        future: UsersService.getFriends(),
        builder:
            (BuildContext context, AsyncSnapshot<GetFriendsResponse> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getFriendRequestsList(snapshot.data.friendship);
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

  Widget getFriendRequestsList(Friendship friendship) {
    return ListView.builder(
      itemCount: friendship.friends.length,
      itemBuilder: (context, index) {
        return FriendRequestWidget(friend: friendship.friends[index]);
      },
    );
  }
}
