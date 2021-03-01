import 'package:azkar/models/user_group.dart';
import 'package:flutter/material.dart';

class GroupListItemWidget extends StatelessWidget {
  final UserGroup userGroup;

  GroupListItemWidget({@required this.userGroup});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userGroup.groupName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
