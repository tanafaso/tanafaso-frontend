import 'package:azkar/main.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/all_challenges_widget.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/personal_challenges/personal_challenges_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class ChallengesMainScreen extends StatefulWidget {
  @override
  _ChallengesMainScreenState createState() => _ChallengesMainScreenState();
}

class _ChallengesMainScreenState extends State<ChallengesMainScreen>
    with TickerProviderStateMixin {
  final allChallengesTabKey = UniqueKey();
  final personalChallengesTabKey = UniqueKey();

  List<Tab> challengesTabs;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(AppLocalizations.of(context).theChallenges);
    challengesTabs = <Tab>[
      Tab(
          key: allChallengesTabKey,
          text: AppLocalizations.of(context).allChallenges),
      Tab(
          key: personalChallengesTabKey,
          text: AppLocalizations.of(context).personalChallenges),
    ];

    _tabController = TabController(vsync: this, length: challengesTabs.length);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            controller: _tabController,
            tabs: challengesTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: challengesTabs.map((Tab tab) {
          if (tab.key == allChallengesTabKey) {
            return AllChallengesWidget();
          } else if (tab.key == personalChallengesTabKey) {
            return PersonalChallengesWidget();
          } else {
            assert(false);
          }
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "mainFloating",
          icon: Icon(Icons.create),
          label: Text(AppLocalizations.of(context).createAChallenge),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateChallengeScreen()));
          }),
    );
  }
}
