import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/friends/add_friend/add_friend_screen.dart';
import 'package:azkar/views/core_views/friends/all_friends/all_friends_widget.dart';
import 'package:azkar/views/core_views/friends/friend_requests/friend_requests_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:share_plus/share_plus.dart';

class FriendsMainScreen extends StatefulWidget {
  @override
  _FriendsMainScreenState createState() => _FriendsMainScreenState();
}

class _FriendsMainScreenState extends State<FriendsMainScreen>
    with TickerProviderStateMixin {
  UniqueKey allFriendsTabKey;
  UniqueKey friendRequestsTabKey;

  List<Tab> friendsTabs;
  TabController _tabController;
  bool _addExpanded;

  List<FriendshipScores> _friendshipScores;
  List<Friend> _pendingFriends;

  @override
  void initState() {
    super.initState();
    _addExpanded = false;
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        // Feature ids for every feature that you want to showcase in order.
        [Features.SHARE_USERNAME, Features.SABEQ_INTRODUCTION],
      );
    });

    allFriendsTabKey = UniqueKey();
    friendRequestsTabKey = UniqueKey();

    _friendshipScores = [];
    _pendingFriends = [];

    HomePage.setAppBarTitle('الأصدقاء');
  }

  Future<void> getNeededData() async {
    try {
      _friendshipScores =
          await ServiceProvider.usersService.getFriendsLeaderboard();
      _friendshipScores = _friendshipScores
          .where((friendshipScore) => !friendshipScore.friend.pending)
          .toList();

      Friendship friendship = await ServiceProvider.usersService.getFriends();
      _pendingFriends =
          friendship.friends.where((friend) => friend.pending).toList();
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
    }
  }

  Widget getAllFriendsTabTitle() {
    return RichText(
        text: TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(
            text: 'الأصدقاء',
            style: new TextStyle(fontWeight: FontWeight.bold)),
        new TextSpan(
          text: ' ',
        ),
        new TextSpan(
            text: '(${_friendshipScores.length.toString()})',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    ));
  }

  Widget getFriendRequestsTabTitle() {
    return RichText(
        text: TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(
            text: 'طلبات صداقة',
            style: new TextStyle(fontWeight: FontWeight.bold)),
        new TextSpan(
          text: ' ',
        ),
        new TextSpan(
            text: '(${_pendingFriends.length.toString()})',
            style: TextStyle(
                color:
                    _pendingFriends.length == 0 ? Colors.black : Colors.green,
                fontWeight: FontWeight.bold)),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getNeededData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          friendsTabs = <Tab>[
            Tab(
              key: allFriendsTabKey,
              child: getAllFriendsTabTitle(),
            ),
            Tab(
              key: friendRequestsTabKey,
              child: getFriendRequestsTabTitle(),
            )
          ];

          _tabController =
              TabController(vsync: this, length: friendsTabs.length);
          return getMainWidget();
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
              child: Text('${AppLocalizations.of(context).loadingFriends}...'),
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
    );
  }

  Widget getMainWidget() {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            controller: _tabController,
            tabs: friendsTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: friendsTabs.map((Tab tab) {
          if (tab.key == allFriendsTabKey) {
            return AllFriendsWidget(
              friendshipScores: _friendshipScores,
              onRefreshRequested: () {
                setState(() {});
              },
            );
          } else if (tab.key == friendRequestsTabKey) {
            return FriendRequestsWidget(
              pendingFriends: _pendingFriends,
              onFriendRequestResolvedCallback: () {
                setState(() {});
              },
            );
          } else {
            assert(false);
          }
        }).toList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: _addExpanded,
            maintainSize: false,
            maintainState: false,
            child: DescribedFeatureOverlay(
                featureId: Features.SHARE_USERNAME,
                barrierDismissible: false,
                backgroundDismissible: false,
                contentLocation: ContentLocation.above,
                tapTarget: Icon(Icons.share),
                // The widget that will be displayed as the tap target.
                description: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(0),
                          )),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              AppLocalizations.of(context).shareUsernameTitle,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(0),
                          )),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              AppLocalizations.of(context)
                                  .shareUsernameExplanation,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                backgroundColor: Theme.of(context).accentColor,
                targetColor: Theme.of(context).primaryColor,
                textColor: Colors.black,
                overflowMode: OverflowMode.wrapBackground,
                child: FloatingActionButton.extended(
                  heroTag: "shareWithFriend",
                  icon: Icon(Icons.share),
                  label: Text(AppLocalizations.of(context).shareWithFriend),
                  onPressed: () async {
                    User currentUser;
                    try {
                      currentUser =
                          await ServiceProvider.usersService.getCurrentUser();
                    } on ApiException catch (e) {
                      SnackBarUtils.showSnackBar(
                        context,
                        '${AppLocalizations.of(context).error}: ${e.error}',
                      );
                      return;
                    }
                    Share.share(AppLocalizations.of(context)
                        .shareMessage(currentUser.username));
                  },
                )),
          ),
          Visibility(
              visible: _addExpanded,
              maintainSize: false,
              child: Padding(padding: EdgeInsets.only(bottom: 8.0))),
          Visibility(
            visible: _addExpanded,
            maintainSize: false,
            child: FloatingActionButton.extended(
                heroTag: "addFriend",
                icon: Icon(Icons.add),
                label: Text(AppLocalizations.of(context).addFriend),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFriendScreen()));
                }),
          ),
          Visibility(
            visible: !_addExpanded,
            maintainSize: false,
            child: FloatingActionButton.extended(
                heroTag: "mainFloating",
                label: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _addExpanded = true;
                  });
                }),
          ),
          Visibility(
              visible: _addExpanded,
              maintainSize: false,
              child: Padding(padding: EdgeInsets.only(bottom: 8.0))),
          Visibility(
            visible: _addExpanded,
            maintainSize: false,
            child: FloatingActionButton.extended(
                heroTag: "minimizeAddFriendButtons",
                label: Icon(Icons.close_outlined),
                onPressed: () {
                  setState(() {
                    _addExpanded = false;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
