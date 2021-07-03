import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/all_challenges_widget.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class ChallengesMainScreen extends StatefulWidget {
  @override
  _ChallengesMainScreenState createState() => _ChallengesMainScreenState();
}

class _ChallengesMainScreenState extends State<ChallengesMainScreen>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    HomePage.setAppBarTitle('التحديات');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllChallengesWidget(),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "mainFloating",
          label: Icon(Icons.create),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateChallengeScreen()));
          }),
    );
  }
}
