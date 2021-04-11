import 'package:azkar/main.dart';
import 'package:azkar/views/core_views/friends/add_friend/add_friend_screen.dart';
import 'package:azkar/views/core_views/friends/all_friends/all_friends_widget.dart';
import 'package:azkar/views/core_views/friends/friend_requests/friend_requests_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

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
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "mainFloating",
          icon: Icon(Icons.add),
          label: Text(AppLocalizations.of(context).addFriend),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddFriendScreen()));
          }),
    );
  }
}
