import 'package:azkar/utils/app_localizations.dart';
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
  int _currentTappedIndex;

  @override
  void initState() {
    super.initState();

    _currentTappedIndex = 0;
    challengesTabs = <Tab>[
      Tab(
          key: allChallengesTabKey,
          // Hack
          text: AppLocalizations(Locale('ar', '')).challengesOfFriends),
      Tab(
          key: personalChallengesTabKey,
          // Hack
          text: AppLocalizations(Locale('ar', '')).personalChallenges),
    ];
    _tabController = TabController(vsync: this, length: challengesTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(AppLocalizations.of(context).theChallenges);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            onTap: (index) {
              _currentTappedIndex = index;
            },
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
            ChallengeTarget target = _currentTappedIndex == 0
                ? ChallengeTarget.FRIEND
                : ChallengeTarget.SELF;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateChallengeScreen(
                          defaultChallengeTarget: target,
                        )));
          }),
    );
  }
}
