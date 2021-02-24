import 'package:azkar/models/Group.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({@required this.group});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: ListView(
        children: [
          Center(
            child: Text('This is the group body'),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text('Invite Friend to Group'),
          ),
          Padding(padding: EdgeInsets.all(5)),
          FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {},
              icon: Icon(Icons.create),
              label: Text('Create Challenge in Group')),
        ],
      ),
    );
  }
}
