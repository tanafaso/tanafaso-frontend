import 'package:azkar/views/entities/challenges/challenges_widget.dart';
import 'package:azkar/views/home_page.dart';
import 'package:flutter/material.dart';

class ShowChallengesWidget extends StatefulWidget {
  final ChallengesWidgetState challengesWidgetState;

  ShowChallengesWidget({Key key, @required this.challengesWidgetState})
      : super(key: key) {
    HomePage.setAppBarTitle('Challenges');
  }

  @override
  _ShowChallengesWidgetState createState() => _ShowChallengesWidgetState();
}

class _ShowChallengesWidgetState extends State<ShowChallengesWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is show challenges widget.'),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Challenge'),
          onPressed: () {
            widget.challengesWidgetState.setChallengesWidgetStateType(
                ChallengesWidgetStateType.addChallenge);
          }),
    );
  }
}
