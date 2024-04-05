import 'package:azkar/models/user.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/core_views/friends/add_friend/invite_facebook_friend_widget.dart';
import 'package:flutter/material.dart';

class FacebookFriendsScreen extends StatelessWidget {
  final List<User> facebookFriends;

  FacebookFriendsScreen({required this.facebookFriends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).inviteFacebookFriends),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getMainWidgetConditionally(context),
      ),
    );
  }

  Widget getMainWidgetConditionally(BuildContext context) {
    if ((facebookFriends.length ?? 0) == 0) {
      return Center(
        child: Text(AppLocalizations.of(context).noFriendsFound),
      );
    }
    return Center(
        child: ListView.builder(
      itemCount: facebookFriends.length,
      itemBuilder: (context, index) {
        return InviteFacebookFriendWidget(
            facebookFriend: facebookFriends[index]);
      },
    ));
  }
}
