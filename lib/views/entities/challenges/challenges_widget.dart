import 'package:azkar/views/entities/challenges/create_challenge/create_challenge_widget.dart';
import 'package:azkar/views/entities/challenges/show_challenges_widget.dart';
import 'package:flutter/material.dart';

enum ChallengesWidgetStateType { addChallenge, showChallenges }

class ChallengesWidget extends StatefulWidget {
  @override
  ChallengesWidgetState createState() => ChallengesWidgetState();
}

class ChallengesWidgetState extends State<ChallengesWidget> {
  ChallengesWidgetStateType challengesWidgetStatetype =
      ChallengesWidgetStateType.showChallenges;

  void setChallengesWidgetStateType(ChallengesWidgetStateType type) {
    setState(() {
      challengesWidgetStatetype = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (challengesWidgetStatetype) {
      case ChallengesWidgetStateType.addChallenge:
        widget = CreateChallengeWidget(
          challengesWidgetState: this,
        );
        break;
      case ChallengesWidgetStateType.showChallenges:
        widget = ShowChallengesWidget(
          challengesWidgetState: this,
        );
        break;
    }

    return Scaffold(
      body: widget,
    );
  }
}
