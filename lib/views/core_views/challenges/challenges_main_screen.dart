import 'package:azkar/utils/features.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/all_challenges_widget.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChallengesMainScreen extends StatefulWidget {
  @override
  _ChallengesMainScreenState createState() => _ChallengesMainScreenState();
}

class _ChallengesMainScreenState extends State<ChallengesMainScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        // Feature ids for every feature that we want to showcase in order.
        [
          Features.CLONE_AND_DELETE,
          Features.CLICK_ZEKR_AFTER_FINISH,
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: AllChallengesWidget()),
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
