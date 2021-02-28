import 'package:azkar/views/core_views/groups/add_group_widget.dart';
import 'package:azkar/views/core_views/groups/all_groups_widget.dart';
import 'package:azkar/views/core_views/groups/group_invitations_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class GroupsMainScreen extends StatefulWidget {
  @override
  _GroupsMainScreenState createState() => _GroupsMainScreenState();
}

class _GroupsMainScreenState extends State<GroupsMainScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> groupsTabs;
  TabController _tabController;

  @override
  void initState() {
    groupsTabs = <Tab>[
      Tab(key: Keys.groupsMainScreenAllGroupsTabKey, text: 'Groups'),
      Tab(
          key: Keys.groupsMainScreenGroupInvitationsTabKey,
          text: 'Group Invitations'),
    ];

    super.initState();
    _tabController = TabController(vsync: this, length: groupsTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle('Groups');

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            key: Keys.groupsMainScreenTabBar,
            controller: _tabController,
            tabs: groupsTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: groupsTabs.map((Tab tab) {
          if (tab.key == Keys.groupsMainScreenAllGroupsTabKey) {
            return AllGroupsWidget();
          } else if (tab.key == Keys.groupsMainScreenGroupInvitationsTabKey) {
            return GroupInvitationsWidget();
          } else {
            assert(false);
          }
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "mainFloating",
          key: Keys.groupsMainScreenFloatingButton,
          icon: Icon(Icons.create),
          label: Text(
            'Create Group',
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddGroupWidget()));
          }),
    );
  }
}
