import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
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
  final allFriendsTabKey = UniqueKey();
  final friendRequestsTabKey = UniqueKey();

  List<Tab> friendsTabs;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        // Feature ids for every feature that you want to showcase in order.
        [Features.SHARE_USERNAME],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(AppLocalizations.of(context).friends);
    friendsTabs = <Tab>[
      Tab(key: allFriendsTabKey, text: AppLocalizations.of(context).friends),
      Tab(
          key: friendRequestsTabKey,
          text: AppLocalizations.of(context).friendRequests),
    ];

    _tabController = TabController(vsync: this, length: friendsTabs.length);

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
            return AllFriendsWidget();
          } else if (tab.key == friendRequestsTabKey) {
            return FriendRequestsWidget();
          } else {
            assert(false);
          }
        }).toList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DescribedFeatureOverlay(
              featureId: Features.SHARE_USERNAME,
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
                heroTag: "secondaryFloating",
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
          Padding(padding: EdgeInsets.only(bottom: 8.0)),
          FloatingActionButton.extended(
              heroTag: "mainFloating",
              icon: Icon(Icons.add),
              label: Text(AppLocalizations.of(context).addFriend),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFriendScreen()));
              }),
        ],
      ),
    );
  }
}
