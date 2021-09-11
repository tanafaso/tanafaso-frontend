import 'dart:io';
import 'dart:math';

import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_azkar_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/friends_progress_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoAzkarChallengeScreen extends StatefulWidget {
  final AzkarChallenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;
  final Group group;

  // Note that some of the challenged users may not be friends.
  final List<String> challengedUsersIds;
  final List<String> challengedUsersFullNames;

  final List<FriendshipScores> friendshipScores;

  DoAzkarChallengeScreen({
    @required this.challenge,
    @required this.group,
    @required this.challengedUsersIds,
    @required this.challengedUsersFullNames,
    @required this.challengeChangedCallback,
    @required this.friendshipScores,
  });

  @override
  _DoAzkarChallengeScreenState createState() => _DoAzkarChallengeScreenState();
}

class _DoAzkarChallengeScreenState extends State<DoAzkarChallengeScreen> {
  ConfettiController confettiControler;
  bool _finishedConfetti;

  @override
  void initState() {
    super.initState();
    _finishedConfetti = false;
    setState(() {
      initConfettiController();
    });
  }

  void initConfettiController() {
    confettiControler =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.challenge.name),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Card(
                    child: Visibility(
                      visible: widget.group != null,
                      child: widget.group == null
                          ? Container()
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 5,
                              ),
                              child: FriendsProgressWidget(
                                challenge:
                                    Challenge(azkarChallenge: widget.challenge),
                                challengedUsersIds: widget.challengedUsersIds,
                                challengedUsersFullNames:
                                    widget.challengedUsersFullNames,
                              ),
                            ),
                    ),
                  ),
                  Visibility(
                    visible: (widget.challenge.motivation?.length ?? 0) != 0,
                    maintainSize: false,
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.directions_run),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 3 / 4,
                              child: Text(
                                widget.challenge.motivation,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: getSubChallenges()),
                ],
              ),
            ),
            getConfettiWidget(),
          ],
        ));
  }

  Align getConfettiWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        confettiController: confettiControler,
        blastDirection: pi,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 10,
        minBlastForce: 3,
        emissionFrequency: 0.5,
        numberOfParticles: 5,
        gravity: 1,
      ),
    );
  }

  Widget getSubChallenges() {
    return ListView.separated(
      padding: EdgeInsets.all(4),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.challenge.subChallenges.length,
      addAutomaticKeepAlives: true,
      separatorBuilder: (BuildContext context, int index) =>
          Padding(padding: EdgeInsets.only(bottom: 4)),
      itemBuilder: (context, index) {
        return DoAzkarChallengeListItemWidget(
          subChallenge: widget.challenge.subChallenges[index],
          challenge: widget.challenge,
          firstItemInList: index == 0,
          callback: (SubChallenge newSubChallenge) async {
            widget.challenge.subChallenges[index] = newSubChallenge;

            widget.challengeChangedCallback(widget.challenge);
            if (widget.challenge.done()) {
              updateAzkarChallenge();

              confettiControler.addListener(() {
                if (confettiControler.state ==
                    ConfettiControllerState.stopped) {
                  onFinishedConfetti();
                }
              });

              confettiControler.play();
            }
          },
        );
      },
    );
  }

  onFinishedConfetti() async {
    // Avoid popping twice if confetti's controller decided to call our listner
    // more than once.
    if (_finishedConfetti) {
      return;
    }
    _finishedConfetti = true;

    bool ratingRequestShown = false;
    if (Platform.isAndroid && widget.challengedUsersIds.length >= 2) {
      var prefs = await ServiceProvider.cacheManager.getPrefs();
      if (!prefs.containsKey(CacheManager.CACHE_KEY_ASKED_FOR_REVIEW)) {
        prefs.setBool(CacheManager.CACHE_KEY_ASKED_FOR_REVIEW, true);
        ratingRequestShown = true;
        await DoChallengeUtils.showReviewDialog(context);
      }
    }

    if (!ratingRequestShown) {
      await DoChallengeUtils.showFriendsScoreDialog(
          context, widget.friendshipScores, widget.challengedUsersIds);
    }
    Navigator.of(context).pop();
  }

  updateAzkarChallenge() async {
    try {
      await ServiceProvider.challengesService
          .updateAzkarChallenge(widget.challenge);
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.errorStatus.errorMessage);
    }
  }

  @override
  void dispose() {
    updateAzkarChallenge();
    confettiControler.dispose();
    super.dispose();
  }
}
