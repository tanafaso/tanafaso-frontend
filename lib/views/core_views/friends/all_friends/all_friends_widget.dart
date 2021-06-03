import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/friends/all_friends/friends_list_item_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/how_to_add_friends_screen.dart';
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
      child: FutureBuilder<Friendship>(
        future: ServiceProvider.usersService.getFriends(),
        builder: (BuildContext context, AsyncSnapshot<Friendship> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getFriendsListWidget(snapshot.data);
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

  Widget getFriendsListWidget(Friendship friendship) {
    if (friendship == null ||
        friendship.friends == null ||
        friendship.friends.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).noFriendsFound,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HowToAddFriendsScreen())),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).howToAddNewFriendsQuestion,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      );
    }

    List<Friend> nonPendingFriends =
        friendship.friends.where((friend) => !friend.pending).toList();
    if (nonPendingFriends.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).noFriendsFound,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HowToAddFriendsScreen())),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).howToAddNewFriendsQuestion,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      key: Keys.allFriendsWidgetListKey,
      itemCount: nonPendingFriends.length,
      itemBuilder: (context, index) {
        return FriendsListItemWidget(
          friend: nonPendingFriends[index],
        );
      },
    );
  }
}
