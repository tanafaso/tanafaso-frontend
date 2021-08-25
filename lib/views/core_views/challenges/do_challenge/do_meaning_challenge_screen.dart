import 'dart:io';
import 'dart:math';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/meaning_challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/animated_score_change_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/friends_progress_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class DoMeaningChallengeScreen extends StatefulWidget {
  final MeaningChallenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;
  final Group group;

  // Note that some of the challenged users may not be friends.
  final List<String> challengedUsersIds;
  final List<String> challengedUsersFullNames;

  final List<FriendshipScores> friendshipScores;

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

    _words = [];
    _meanings = [];
    for (int i = 0; i < widget.challenge.words.length; i++) {
      print(widget.challenge.words[i]);
      _words.add(TextIndex(text: widget.challenge.words[i], index: i));
    }
    for (int i = 0; i < widget.challenge.meanings.length; i++) {
      print(widget.challenge.meanings[i]);
      _meanings.add(TextIndex(text: widget.challenge.meanings[i], index: i));
    }
    _words.shuffle();
    _meanings.shuffle();

    _chosenWordIndex = -1;

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
          title: Text(widget.challenge.getName()),
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
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
                                  challenge: Challenge(
                                      meaningChallenge: widget.challenge),
                                  challengedUsersIds: widget.challengedUsersIds,
                                  challengedUsersFullNames:
                                      widget.challengedUsersFullNames,
                                ),
                              ),
                      ),
                    ),
                    Divider(),
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
                                  Text('الكلمات',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                  ),
                                  ListView.separated(
                                    separatorBuilder: (context, _) => Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                    ),
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
                                                            _words[index]
                                                                .index
                                                        ? Color(0xffcef5ce)
                                                        : Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                  child: Text(
                                                    _words[index].text,
                                                    textAlign:
                                                        TextAlign.center,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 17),
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
                    Divider(),
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
                                  Text(
                                    'المعاني',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                  ),
                                  ListView.separated(
                                    separatorBuilder: (context, _) => Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                    ),
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
                                                      const EdgeInsets.all(
                                                          8.0),
                                                  child: Text(
                                                    _meanings[index].text,
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 17),
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
    print(_meanings[indexInList].index.toString() +
        " " +
        _chosenWordIndex.toString());
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
          SnackBarUtils.showSnackBar(context, e.error);
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
      if (!prefs.containsKey(CacheManager.CAHCE_KEY_ASKED_FOR_REVIEW)) {
        prefs.setBool(CacheManager.CAHCE_KEY_ASKED_FOR_REVIEW, true);
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
    _colorAnimationController.dispose();
    super.dispose();
  }
}
