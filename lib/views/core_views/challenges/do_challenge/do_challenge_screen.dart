import 'dart:math';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class DoChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;
  final Group group;
  final List<String> friendsIds;
  final List<String> friendsFullNames;
  final bool isPersonalChallenge;

  DoChallengeScreen(
      {@required this.challenge,
      this.group,
      this.friendsIds,
      this.friendsFullNames,
      @required this.challengeChangedCallback,
      @required this.isPersonalChallenge});

  @override
  _DoChallengeScreenState createState() => _DoChallengeScreenState();
}

class _DoChallengeScreenState extends State<DoChallengeScreen> {
  ConfettiController confettiControler;

  @override
  void initState() {
    super.initState();
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
        body: Center(
          child: Column(
            children: [
              getConfettiWidget(),
              Card(
                child: Visibility(
                  visible: !widget.isPersonalChallenge && widget.group != null,
                  child: !(!widget.isPersonalChallenge && widget.group != null)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                            shrinkWrap: true,
                            itemCount: widget.friendsIds.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: getFriendProgressOnChallengeIcon(
                                        widget.friendsIds[index]),
                                  ),
                                  Text(widget.friendsFullNames[index]),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ),
              Card(
                child: Visibility(
                  visible: (widget.challenge.motivation?.length ?? 0) != 0,
                  maintainSize: false,
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
                            softWrap: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !widget.challenge.done(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .clickOnZekrAfterReadingIt,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ))),
                ),
              ),
              Expanded(
                  child: Container(
                child: getSubChallenges(),
              )),
            ],
          ),
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

  Widget getFriendProgressOnChallengeIcon(String userId) {
    if (userId == null) {
      return Container();
    }

    if (widget.challenge.usersFinished
        .any((userFinished) => userFinished == userId)) {
      return Icon(
        Icons.done_outline,
        size: 15,
        color: Colors.green,
      );
    }

    if (widget.challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        size: 15,
        color: Colors.red,
      );
    }

    return Icon(
      Icons.not_started,
      size: 15,
      color: Colors.yellow,
    );
  }

  Widget getIconConditionally() {
    if (widget.challenge.done()) {
      return Icon(
        Icons.done_outline,
        color: Colors.green,
      );
    }
    if (widget.challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
      );
    }
    return Icon(
      Icons.not_started,
      color: Colors.yellow,
    );
  }

  Widget getSubChallenges() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.challenge.subChallenges.length,
      itemBuilder: (context, index) {
        return DoChallengeSubChallengeListItemWidget(
          subChallenge: widget.challenge.subChallenges[index],
          challenge: widget.challenge,
          callback: (SubChallenge newSubChallenge) async {
            widget.challenge.subChallenges[index] = newSubChallenge;
            try {
              widget.isPersonalChallenge
                  ? await ServiceProvider.challengesService
                      .updatePersonalChallenge(widget.challenge)
                  : await ServiceProvider.challengesService
                      .updateChallenge(widget.challenge);
            } on ApiException catch (e) {
              SnackBarUtils.showSnackBar(context, e.error);
            }

            widget.challengeChangedCallback(widget.challenge);
            if (widget.challenge.done()) {
              confettiControler.addListener(() {
                if (confettiControler.state ==
                    ConfettiControllerState.stopped) {
                  Navigator.of(context).pop();
                }
              });

              confettiControler.play();
            }
          },
        );
      },
    );
  }
}
