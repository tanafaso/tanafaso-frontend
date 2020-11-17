import 'package:azkar/views/entities/friends/add_friend_widget.dart';
import 'package:azkar/views/entities/friends/show_friends_widget.dart';
import 'package:flutter/material.dart';

enum FriendsWidgetStateType { addFriend, showFriends }

class FriendsWidget extends StatefulWidget {
  @override
  FriendsWidgetState createState() => FriendsWidgetState();
}

class FriendsWidgetState extends State<FriendsWidget> {
  FriendsWidgetStateType FriendsWidgetStatetype =
      FriendsWidgetStateType.showFriends;

  void setFriendsWidgetStateType(FriendsWidgetStateType type) {
    setState(() {
      FriendsWidgetStatetype = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (FriendsWidgetStatetype) {
      case FriendsWidgetStateType.addFriend:
        widget = AddFriendWidget(
          friendsWidgetState: this,
        );
        break;
      case FriendsWidgetStateType.showFriends:
        widget = ShowFriendsWidget(
          friendsWidgetState: this,
        );
        break;
    }

    return Scaffold(
      body: widget,
    );
  }
}
