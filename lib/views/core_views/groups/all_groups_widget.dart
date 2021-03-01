import 'package:azkar/models/user_group.dart';
import 'package:azkar/net/payload/groups/responses/get_groups_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/groups/group_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllGroupsWidget extends StatefulWidget {
  @override
  _AllGroupsWidgetState createState() => _AllGroupsWidgetState();
}

class _AllGroupsWidgetState extends State<AllGroupsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GetGroupsResponse>(
        future: ServiceProvider.groupsService.getGroups(),
        builder:
            (BuildContext context, AsyncSnapshot<GetGroupsResponse> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getGroupsListWidget(snapshot.data.userGroups);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Retrieving groups...'),
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

  Widget getGroupsListWidget(List<UserGroup> userGroups) {
    if (userGroups.isEmpty) {
      return Center(
        child: Text(
          'No groups found.',
          key: Keys.allGroupsWidgetNoGroupsFoundKey,
        ),
      );
    }

    return ListView.builder(
      // key: Keys.allFriendsWidgetList,
      itemCount: userGroups.length,
      itemBuilder: (context, index) {
        return GroupListItemWidget(
          userGroup: userGroups[index],
        );
      },
    );
  }
}
