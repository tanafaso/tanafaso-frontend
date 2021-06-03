import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/friends/all_friends/detailed_friend_list_item_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/no_friends_found_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/summary_friend_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AllFriendsWidget extends StatefulWidget {
  @override
  _AllFriendsWidgetState createState() => _AllFriendsWidgetState();
}

class _AllFriendsWidgetState extends State<AllFriendsWidget> {
  bool _detailedView;
  int _toggleIndex;

  @override
  void initState() {
    super.initState();
    _detailedView = true;
    _toggleIndex = 0;
  }

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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ToggleSwitch(
            minWidth: MediaQuery.of(context).size.width,
            cornerRadius: 20.0,
            activeBgColor: Colors.white,
            activeFgColor: Colors.black,
            inactiveBgColor: Colors.black,
            inactiveFgColor: Colors.white,
            initialLabelIndex: _toggleIndex,
            labels: [
              AppLocalizations.of(context).detailedView,
              AppLocalizations.of(context).summaryView,
            ],
            fontSize: 20,
            // icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
            onToggle: (index) {
              setState(() {
                _toggleIndex = index;
                _detailedView = index == 0;
              });
            },
          ),
        ),
        Flexible(
          child: ListView.builder(
            key: Keys.allFriendsWidgetListKey,
            itemCount: friendshipScores.length,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return _detailedView
                  ? DetailedFriendListItemWidget(
                      friendshipScores: friendshipScores[index],
                    )
                  : SummaryFriendListItemWidget(
                      friendshipScores: friendshipScores[index],
                    );
            },
          ),
        ),
      ],
    );
  }
}
