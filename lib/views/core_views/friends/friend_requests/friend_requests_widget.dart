import 'package:azkar/models/friend.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/core_views/friends/friend_requests/friend_request_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendRequestsWidget extends StatefulWidget {
  final List<Friend> pendingFriends;
  final OnFriendRequestResolvedCallback onFriendRequestResolvedCallback;

  FriendRequestsWidget({
    @required this.pendingFriends,
    @required this.onFriendRequestResolvedCallback,
  });

  @override
  _FriendRequestsWidgetState createState() => _FriendRequestsWidgetState();
}

class _FriendRequestsWidgetState extends State<FriendRequestsWidget> {
  @override
  Widget build(BuildContext context) {
    if ((widget.pendingFriends?.length ?? 0) == 0) {
      return Center(
        child: Text(AppLocalizations.of(context).noFriendRequestsFound),
      );
    }
    return ListView.builder(
      itemCount: widget.pendingFriends.length,
      itemBuilder: (context, index) {
        return FriendRequestWidget(
          friend: widget.pendingFriends[index],
          onFriendRequestResolvedCallback:
              widget.onFriendRequestResolvedCallback,
        );
      },
    );
  }
}
