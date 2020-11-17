import 'package:azkar/views/entities/friends/friends_widget.dart';
import 'package:azkar/views/home_page.dart';
import 'package:flutter/material.dart';

class ShowFriendsWidget extends StatefulWidget {
  final FriendsWidgetState friendsWidgetState;

  ShowFriendsWidget({Key key, @required this.friendsWidgetState})
      : super(key: key) {
    HomePage.setAppBarTitle('Show Friends');
  }

  @override
  _ShowFriendsWidgetState createState() => _ShowFriendsWidgetState();
}

class _ShowFriendsWidgetState extends State<ShowFriendsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is show friends widget.'),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Friend'),
          onPressed: () {
            widget.friendsWidgetState
                .setFriendsWidgetStateType(FriendsWidgetStateType.addFriend);
          }),
    );
  }
}
