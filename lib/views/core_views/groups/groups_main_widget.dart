import 'package:azkar/views/core_views/groups/all_groups/all_groups_widget.dart';
import 'package:azkar/views/core_views/groups/create_group/add_group_widget.dart';
import 'package:azkar/views/core_views/groups/group_invitations/group_invitations_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class GroupsMainWidget extends StatefulWidget {
  @override
  _GroupsMainWidgetState createState() => _GroupsMainWidgetState();
}

class _GroupsMainWidgetState extends State<GroupsMainWidget>
    with SingleTickerProviderStateMixin {
  List<Tab> groupsTabs;
  TabController _tabController;

  @override
  void initState() {
    groupsTabs = <Tab>[
      Tab(key: Keys.groupsMainWidgetAllGroupsTabKey, text: 'Groups'),
      Tab(
          key: Keys.groupsMainWidgetGroupInvitationsTabKey,
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
            key: Keys.groupsMainWidgetTabBar,
            controller: _tabController,
            tabs: groupsTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: groupsTabs.map((Tab tab) {
          if (tab.key == Keys.groupsMainWidgetAllGroupsTabKey) {
            return AllGroupsWidget();
          } else if (tab.key == Keys.groupsMainWidgetGroupInvitationsTabKey) {
            return GroupInvitationsWidget();
          } else {
            assert(false);
          }
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          key: Keys.groupsMainWidgetFloatingButton,
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
