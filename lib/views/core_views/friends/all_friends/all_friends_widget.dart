import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/friends/all_friends/friend_list_item_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/no_friends_found_widget.dart';
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
      child: FutureBuilder<List<FriendshipScores>>(
        future: ServiceProvider.usersService.getFriendsLeaderboard(),
        builder: (BuildContext context,
            AsyncSnapshot<List<FriendshipScores>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getMainWidget(snapshot.data);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SnapshotUtils.getErrorWidget(context, snapshot),
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

  Widget getMainWidget(List<FriendshipScores> friendshipScores) {
    if (friendshipScores == null || friendshipScores.isEmpty) {
      return NoFriendsFoundWidget();
    }

    return ListView.builder(
      key: Keys.allFriendsWidgetListKey,
      itemCount: friendshipScores.length,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return FriendListItemWidget(
          friendshipScores: friendshipScores[index],
        );
      },
    );
  }
}
