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
import 'package:azkar/views/core_views/friends/all_friends/friend_list_item_loading_widget.dart';
import 'package:azkar/views/core_views/friends/friend_requests/friend_requests_widget.dart';
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

  Future<void> _neededData;

  int _tabIndex;

  @override
  void initState() {
    super.initState();
    _addExpanded = false;

    allFriendsTabKey = UniqueKey();
    friendRequestsTabKey = UniqueKey();

    _friendshipScores = [];
    _pendingFriends = [];

    _neededData = getNeededData();

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        // Feature ids for every feature that we want to showcase in order.
        [
          Features.SABEQ_INTRODUCTION,
          Features.ADD_FRIEND,
          Features.SHARE_USERNAME,
        ],
      );
    });

    _tabIndex = 0;
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
      SnackBarUtils.showSnackBar(context, e.errorStatus.errorMessage);
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
    return SafeArea(
      child: FutureBuilder<void>(
        future: _neededData,
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

            _tabController = TabController(
                vsync: this,
                length: friendsTabs.length,
                initialIndex: _tabIndex);
            _tabController.addListener(() {
              setState(() {
                _tabIndex = _tabController.index;
              });
            });
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
            children = List.generate(5, (_) => FriendListItemLoadingWidget());
          }
          // Add space for the top tap.
          children.insert(
            0,
            Container(
              height: MediaQuery.of(context).size.height / 11,
            ),
          );
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
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
                setState(() {
                  _neededData = getNeededData();
                });
              },
            );
          } else if (tab.key == friendRequestsTabKey) {
            return FriendRequestsWidget(
              pendingFriends: _pendingFriends,
              onFriendRequestResolvedCallback: () {
                setState(() {
                  _neededData = getNeededData();
                });
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
                        '${AppLocalizations.of(context).error}: ${e.errorStatus.errorMessage}',
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
            child: DescribedFeatureOverlay(
                featureId: Features.ADD_FRIEND,
                barrierDismissible: false,
                backgroundDismissible: false,
                contentLocation: ContentLocation.above,
                tapTarget: Icon(Icons.add),
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
                              "إضافة صديق",
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
                              "اضغط هنا لإضافة صديق أو مشاركة التطبيق مع صديق",
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
                    heroTag: "addFloatingButton",
                    label: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _addExpanded = true;
                      });
                    })),
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
