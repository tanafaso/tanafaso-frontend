import 'package:azkar/models/user.dart';
import 'package:azkar/views/entities/friends/invite_facebook_friend_widget.dart';
import 'package:flutter/material.dart';

class FacebookFriendsScreen extends StatelessWidget {
  final List<User> facebookFriends;

  FacebookFriendsScreen({@required this.facebookFriends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Facebook Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: ListView.builder(
          itemCount: facebookFriends.length,
          itemBuilder: (context, index) {
            return InviteFacebookFriendWidget(
                facebookFriend: facebookFriends[index]);
          },
        )),
      ),
    );
  }
}
