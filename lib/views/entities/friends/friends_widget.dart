import 'package:azkar/views/entities/friends/add_friend_widget.dart';
import 'package:azkar/views/entities/friends/show_all_friends_widget.dart';
import 'package:azkar/views/entities/friends/show_friend_requests_widget.dart';
import 'package:azkar/views/home_page.dart';
import 'package:flutter/material.dart';

class FriendsWidget extends StatefulWidget {

  FriendsWidget({Key key})
      : super(key: key) {
    HomePage.setAppBarTitle('Friends');
  }

  @override
  _FriendsWidgetState createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget>
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
