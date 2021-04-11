import 'package:azkar/main.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/friends/friend_requests/friend_request_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendRequestsWidget extends StatefulWidget {
  @override
  _FriendRequestsWidgetState createState() => _FriendRequestsWidgetState();
}

class _FriendRequestsWidgetState extends State<FriendRequestsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GetFriendsResponse>(
        future: ServiceProvider.usersService.getFriends(),
        builder:
            (BuildContext context, AsyncSnapshot<GetFriendsResponse> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getFriendRequestsListWidget(
                context, snapshot.data.friendship);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                    '${AppLocalizations.of(context).error}: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child:
                    Text('${AppLocalizations.of(context).loadingFriends}...'),
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

  Widget getFriendRequestsListWidget(
      BuildContext context, Friendship friendship) {
    List<Friend> pendingFriends =
        friendship.friends.where((friend) => friend.pending).toList();
    if ((pendingFriends?.length ?? 0) == 0) {
      return Center(
        child: Text(AppLocalizations.of(context).noFriendRequestsFound),
      );
    }
    return ListView.builder(
      itemCount: pendingFriends.length,
      itemBuilder: (context, index) {
        return FriendRequestWidget(
          friend: pendingFriends[index],
          parentState: this,
        );
      },
    );
  }
}
