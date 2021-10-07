import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/meaning_challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/friends_progress_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoMeaningChallengeScreen extends StatefulWidget {
  final MeaningChallenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;
  final Group group;

  // Note that some of the challenged users may not be friends.
  final List<String> challengedUsersIds;
  final List<String> challengedUsersFullNames;

  final List<Friend> friendshipScores;

  DoMeaningChallengeScreen({
    @required this.challenge,
    @required this.group,
    @required this.challengedUsersIds,
    @required this.challengedUsersFullNames,
    @required this.challengeChangedCallback,
    @required this.friendshipScores,
  });

  @override
  _DoMeaningChallengeScreenState createState() =>
      _DoMeaningChallengeScreenState();
}

class TextIndex {
  final String text;
  final int index;

  TextIndex({this.text, this.index});
}

class _DoMeaningChallengeScreenState extends State<DoMeaningChallengeScreen>
    with SingleTickerProviderStateMixin {
  ConfettiController confettiControler;
  bool _finishedConfetti;
  bool _shouldChooseWord;

  AnimationController _colorAnimationController;
  Animation _colorAnimation;

  List<TextIndex> _words;
  List<TextIndex> _meanings;

  int _chosenWordIndex;

  ScrollController _pageScrollController;
  bool _friendsTileExpanded;

  @override
  void initState() {
    super.initState();

    _finishedConfetti = false;
    _shouldChooseWord = true;
    _colorAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(begin: Color(0xffcef5ce), end: Colors.white)
        .animate(_colorAnimationController);
    _friendsTileExpanded = true;

    _words = [];
    _meanings = [];
    for (int i = 0; i < widget.challenge.words.length; i++) {
      _words.add(TextIndex(text: widget.challenge.words[i], index: i));
    }
    for (int i = 0; i < widget.challenge.meanings.length; i++) {
      _meanings.add(TextIndex(text: widget.challenge.meanings[i], index: i));
    }
    _words.shuffle();
    _meanings.shuffle();

    _chosenWordIndex = -1;

    _pageScrollController = ScrollController();
    initConfettiController();
  }

  void initConfettiController() {
    confettiControler =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            widget.challenge.getName(),
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _pageScrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: Text(
                      "الأصدقاء",
                      style: TextStyle(
                          fontSize: _friendsTileExpanded ? 25 : 20,
                          fontWeight: FontWeight.bold),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    collapsedTextColor: Colors.black,
                    collapsedIconColor: Colors.black,
                    trailing: Icon(
                      _friendsTileExpanded
                          ? Icons.arrow_drop_down_circle
                          : Icons.arrow_drop_down,
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() => _friendsTileExpanded = expanded);
                    },
                    children: [
                      Divider(),
                      Visibility(
                        visible: widget.group != null,
                        child: widget.group == null
                            ? Container()
                            : FriendsProgressWidget(
                                challenge: Challenge(
                                    meaningChallenge: widget.challenge),
                                challengedUsersIds: widget.challengedUsersIds,
                                challengedUsersFullNames:
                                    widget.challengedUsersFullNames,
                              ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color:
                              _shouldChooseWord ? Colors.white : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                AutoSizeText('الكلمات',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                ListView.separated(
                                  separatorBuilder: (context, _) => Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                  ),
                                  controller: _pageScrollController,
                                  itemCount: _words.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AnimatedBuilder(
                                      animation: _colorAnimation,
                                      builder: (context, _) =>
                                          RawMaterialButton(
                                              onPressed: () =>
                                                  onWordPressed(index),
                                              elevation: 2,
                                              fillColor: _shouldChooseWord
                                                  ? _colorAnimation.value
                                                  : _chosenWordIndex ==
                                                          _words[index].index
                                                      ? Color(0xffcef5ce)
                                                      : Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  _words[index].text,
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color:
                              _shouldChooseWord ? Colors.white : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  'المعاني',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                ),
                                ListView.separated(
                                  separatorBuilder: (context, _) => Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                  ),
                                  controller: _pageScrollController,
                                  itemCount: _meanings.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AnimatedBuilder(
                                      animation: _colorAnimation,
                                      builder: (context, _) =>
                                          RawMaterialButton(
                                              onPressed: () =>
                                                  onMeaningPressed(index),
                                              elevation: 2,
                                              fillColor: _shouldChooseWord
                                                  ? Colors.white
                                                  : _colorAnimation.value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  _meanings[index].text,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                  softWrap: true,
                                                ),
                                              )),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            getConfettiWidget(),
          ],
        ));
  }

  void onWordPressed(int indexInList) {
    setState(() {
      _chosenWordIndex = _words[indexInList].index;
      _shouldChooseWord = false;
    });
  }

  void onMeaningPressed(int indexInList) async {
    if (_shouldChooseWord) {
      SnackBarUtils.showSnackBar(
        context,
        'اختر كلمة',
      );
      return;
    }
    if (_meanings[indexInList].index == _chosenWordIndex) {
      if (_words.length == 1) {
        // last one is chosen correctly.
        try {
          await ServiceProvider.challengesService
              .finishMeaningChallenge(widget.challenge.id);
        } on ApiException catch (e) {
          SnackBarUtils.showSnackBar(context, e.errorStatus.errorMessage);
          return;
        }
      }

      setState(() {
        SnackBarUtils.showSnackBar(
          context,
          'اختيار صحيح',
          color: Colors.green.shade400,
        );
        _shouldChooseWord = true;
        _words.removeWhere((element) => element.index == _chosenWordIndex);
        _meanings.removeAt(indexInList);
        _chosenWordIndex = -1;

        if (_words.length == 0) {
          confettiControler.addListener(() {
            if (confettiControler.state == ConfettiControllerState.stopped) {
              onFinishedConfetti();
            }
          });

          confettiControler.play();
        }
      });
    } else {
      SnackBarUtils.showSnackBar(
        context,
        'اختيار خاطئ ، حاول مرة أخرى',
      );
    }
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

  @override
  void dispose() {
    confettiControler.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }
}
