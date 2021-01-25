import 'package:azkar/views/core_views/friends/add_friend/add_friend_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/show_all_friends_widget.dart';
import 'package:azkar/views/core_views/friends/friend_requests/show_friend_requests_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class FriendsMainWidget extends StatefulWidget {
  @override
  _FriendsMainWidgetState createState() => _FriendsMainWidgetState();
}

class _FriendsMainWidgetState extends State<FriendsMainWidget>
    with SingleTickerProviderStateMixin {
  final showAllFriendsTabKey = UniqueKey();
  final showFriendRequestsTabKey = UniqueKey();

  List<Tab> showFriendsTabs;
  TabController _tabController;

  @override
  void initState() {
    showFriendsTabs = <Tab>[
      Tab(key: showAllFriendsTabKey, text: 'Friends'),
      Tab(key: showFriendRequestsTabKey, text: 'Friend Requests'),
    ];

    super.initState();
    _tabController = TabController(vsync: this, length: showFriendsTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle('Friends');

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            controller: _tabController,
            tabs: showFriendsTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: showFriendsTabs.map((Tab tab) {
          if (tab.key == showAllFriendsTabKey) {
            return ShowAllFriendsWidget();
          } else if (tab.key == showFriendRequestsTabKey) {
            return ShowFriendRequestsWidget();
          } else {
            assert(false);
          }
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Friend'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddFriendWidget()));
          }),
    );
  }
}
