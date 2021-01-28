import 'package:flutter/material.dart';

class CreateGroupWidget extends StatefulWidget {
  @override
  _CreateGroupWidgetState createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Challenge'),
        ),
        body: Center(
          child: Text('Create Challenge widget'),
        ));
  }
}
