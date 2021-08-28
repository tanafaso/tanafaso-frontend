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
import 'package:azkar/views/core_views/challenges/do_challenge/animated_score_change_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_azkar_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/friends_progress_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

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
            try {
              await ServiceProvider.challengesService
                  .updateAzkarChallenge(widget.challenge);
            } on ApiException catch (e) {
              SnackBarUtils.showSnackBar(context, e.error);
            }

            widget.challengeChangedCallback(widget.challenge);
            if (widget.challenge.done()) {
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
        await showReviewDialog(context);
      }
    }

    if (!ratingRequestShown) {
      await showFriendsScoreDialog();
    }
    Navigator.of(context).pop();
  }

  Future<void> showReviewDialog(BuildContext context) {
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text("لا شكرا"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text("قيم التطبيق"),
      onPressed: () {
        InAppReview.instance.openStoreListing();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تقييم التطبيق"),
      content: Text("هل يمكنك تقييم التطبيق إذا كنت تعتقد أنه مفيد؟ 😊"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> showFriendsScoreDialog() async {
    List<FriendshipScores> relevantFriendScores = widget.friendshipScores
        .where((friendshipScore) =>
            widget.challengedUsersIds.contains(friendshipScore.friend.userId))
        .toList();

    var scrollController = ScrollController();

    await showDialog(
      context: context,
      builder: (_) => Center(
        child: SizedBox(
          width: double.maxFinite,
          child: Card(
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'استمر في تحفيز أصدقائك وتحديهم 🔥',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 3),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: scrollController,
                      child: ListView.separated(
                          padding: EdgeInsets.all(0),
                          addAutomaticKeepAlives: true,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          shrinkWrap: true,
                          itemCount: relevantFriendScores.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            return AnimatedScoreChangeWidget(
                              friendshipScores: relevantFriendScores[index],
                            );
                          }),
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Text(
                    '💪',
                    style: TextStyle(fontSize: 25),
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    confettiControler.dispose();
    super.dispose();
  }
}
