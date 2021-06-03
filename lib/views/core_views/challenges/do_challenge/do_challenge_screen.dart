import 'dart:math';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/friends_progress_widget.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class DoChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;
  final Group group;

  // Note that some of the challenged users may not be friends.
  final List<String> challengedUsersIds;
  final List<String> challengedUsersFullNames;
  final bool isPersonalChallenge;

  DoChallengeScreen(
      {@required this.challenge,
      this.group,
      this.challengedUsersIds,
      this.challengedUsersFullNames,
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
        body: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Card(
                    child: Visibility(
                      visible:
                          !widget.isPersonalChallenge && widget.group != null,
                      child: !(!widget.isPersonalChallenge &&
                              widget.group != null)
                          ? Container()
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 5,
                              ),
                              child: FriendsProgressWidget(
                                challenge: widget.challenge,
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
        return DoChallengeSubChallengeListItemWidget(
          subChallenge: widget.challenge.subChallenges[index],
          challenge: widget.challenge,
          firstItemInList: index == 0,
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
