import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/payload/challenges/requests/add_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/requests/add_friends_challenge_request_body.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_azkar/selected_azkar_widget.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/selected_friends_widget.dart';
import 'package:flutter/material.dart';

enum ChallengeTarget { SELF, FRIENDS }

// ignore: must_be_immutable
class CreateChallengeScreen extends StatefulWidget {
  List<Friend> initiallySelectedFriends;
  List<SubChallenge> initiallySelectedSubChallenges;
  String initiallyChosenName;
  String initiallyChosenMotivation;
  ChallengeTarget defaultChallengeTarget;

  CreateChallengeScreen({
    this.initiallySelectedFriends = const [],
    this.initiallySelectedSubChallenges = const [],
    this.initiallyChosenName = "",
    this.initiallyChosenMotivation = "",
    this.defaultChallengeTarget = ChallengeTarget.FRIENDS,
  });

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  ChallengeTarget _challengeTarget = ChallengeTarget.FRIENDS;
  TextEditingController _challengeNameController;
  String _lastChallengeName = '';
  TextEditingController _motivationController;
  TextEditingController _expiresAfterDayNumController;
  String _lastExpiresAfterDayNum = '١';
  List<SubChallenge> _subChallenges;
  bool _subChallengesValid;
  List<Friend> _selectedFriends;

  initChallengeNameController() {
    _challengeNameController = TextEditingController(text: _lastChallengeName);
    _challengeNameController.addListener(() {
      if (_lastChallengeName == _challengeNameController.value.text) {
        return;
      }
      _lastChallengeName = _challengeNameController.value.text;
      validateChallengeName(true);
      setState(() {});
    });
  }

  bool validateChallengeName(bool showWarning) {
    final String newChallengeName = _challengeNameController.value.text;
    if (newChallengeName.isEmpty) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
          context,
          AppLocalizations.of(context).nameShouldNotBeEmpty,
        );
      }
      return false;
    }
    return true;
  }

  initMotivationController() {
    _motivationController = TextEditingController(text: '');
  }

  bool validateMotivation() {
    final String motivation = _motivationController.value.text;
    // Note: Characters function is used here so as to count the actual number
    // of runes and not only the number of UTF-16 code points, because our
    // use-case with arabic language, there are some letters with tashkeel that
    // can only be represented in UTF-8 in 4 bytes.
    if (motivation.characters.length > 100) {
      return false;
    }
    return true;
  }

  initExpiresAfterDayNumController() {
    _expiresAfterDayNumController = TextEditingController(text: '١');
    _expiresAfterDayNumController.addListener(() {
      if (_lastExpiresAfterDayNum == _expiresAfterDayNumController.value.text) {
        return;
      }
      _lastExpiresAfterDayNum = _expiresAfterDayNumController.value.text;
      validateExpiresAfterDaysNum(true);
      setState(() {});
    });
  }

  bool validateExpiresAfterDaysNum(bool showWarning) {
    final String newExpiresAfterDayNum =
        _expiresAfterDayNumController.value.text;

    int newExpiresAfterDaysNumInt = 0;
    try {
      newExpiresAfterDaysNumInt =
          ArabicUtils.stringToNumber(newExpiresAfterDayNum);
    } on FormatException {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
            context, AppLocalizations.of(context).daysMustBeANumberFrom1to100);
      }
      return false;
    }
    if (newExpiresAfterDaysNumInt <= 0) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
            context, AppLocalizations.of(context).daysMustBeMoreThan0);
      }
      return false;
    }

    if (newExpiresAfterDaysNumInt > 100) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
            context, AppLocalizations.of(context).daysMustBeLessThanOrEqual100);
      }
      return false;
    }
    return true;
  }

  @override
  void initState() {
    initChallengeNameController();
    initMotivationController();
    initExpiresAfterDayNumController();
    _subChallenges = widget.initiallySelectedSubChallenges;
    _challengeNameController =
        TextEditingController(text: widget.initiallyChosenName);
    _motivationController =
        TextEditingController(text: widget.initiallyChosenMotivation);
    _subChallengesValid = _subChallenges.length > 0;
    _challengeTarget = widget.defaultChallengeTarget;
    _selectedFriends = widget.initiallySelectedFriends;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).createAChallenge),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Center(
            child: Container(
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '*',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.grading),
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context).iWantTo} ...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 1),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Tooltip(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(8),
                                      message: AppLocalizations.of(context)
                                          .challengeTargetHint,
                                      showDuration: Duration(seconds: 5),
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              RadioListTile<ChallengeTarget>(
                                activeColor: Colors.green,
                                title: Row(
                                  children: [
                                    Text(AppLocalizations.of(context)
                                        .challengeMyself),
                                  ],
                                ),
                                dense: false,
                                value: ChallengeTarget.SELF,
                                groupValue: _challengeTarget,
                                onChanged: (ChallengeTarget value) {
                                  setState(() {
                                    _challengeTarget = value;
                                  });
                                },
                              ),
                              RadioListTile<ChallengeTarget>(
                                activeColor: Colors.green,
                                title: Row(
                                  children: [
                                    Text(AppLocalizations.of(context)
                                        .challengeFriends),
                                  ],
                                ),
                                dense: false,
                                value: ChallengeTarget.FRIENDS,
                                groupValue: _challengeTarget,
                                onChanged: (ChallengeTarget value) {
                                  setState(() {
                                    _challengeTarget = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _challengeTarget == ChallengeTarget.FRIENDS,
                          maintainState: true,
                          child: SelectedFriendsWidget(
                            initiallySelectedFriends:
                                widget.initiallySelectedFriends,
                            onSelectedFriendsChanged: (newFriends) {
                              setState(() {
                                print('changed');
                                _selectedFriends = newFriends;
                              });
                            },
                          ),
                        ),
                        SelectedAzkarWidget(
                          onSelectedAzkarChangedCallback: (newSubChallenges) {
                            setState(() {
                              _subChallenges = newSubChallenges;
                            });
                          },
                          onSelectedAzkarValidityChangedCallback:
                              (subChallengesValid) {
                            setState(() {
                              _subChallengesValid = subChallengesValid;
                            });
                          },
                          initiallySelectedSubChallenges: _subChallenges,
                        ),
                        Card(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          '*',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                            Icons.drive_file_rename_outline),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .challengeName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Tooltip(
                                          message: AppLocalizations.of(context)
                                              .writeANameWithWhichYouCanDistinguishTheChallenge,
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLength: 25,
                                  maxLines: 1,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    alignLabelWithHint: true,
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.teal)),
                                  ),
                                  controller: _challengeNameController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '*',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.date_range),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).deadline,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                          .challengeExpiresAfter,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 70,
                                        height: 30,
                                        alignment: Alignment.center,
                                        child: Card(
                                          elevation: 1,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            decoration: new InputDecoration(
                                              alignLabelWithHint: true,
                                              border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors.teal)),
                                            ),
                                            // textInputAction: TextInputAction.done,
                                            keyboardType: TextInputType.number,
                                            controller:
                                                _expiresAfterDayNumController,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).day,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.directions_run),
                                      Padding(
                                          padding: EdgeInsets.only(left: 8)),
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .theMotivationMessage,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8)),
                                        ],
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                      )),
                                      Tooltip(
                                        message: AppLocalizations.of(context)
                                            .writeSomethingToMotivateYourFriendToSayTheZekr,
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLength: 100,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    alignLabelWithHint: true,
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.teal)),
                                  ),
                                  controller: _motivationController,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: ButtonTheme(
                        height: 50,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () async => onCreatePressed(),
                          child: Center(
                              child: Text(
                            readyToFinishChallenge(false)
                                ? AppLocalizations.of(context).add
                                : AppLocalizations.of(context).addNotReady,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: readyToFinishChallenge(false)
                              ? Colors.green.shade300
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green.shade200,
                                offset: Offset(1, -2),
                                blurRadius: 5),
                            BoxShadow(
                                color: Colors.green.shade200,
                                offset: Offset(-1, 2),
                                blurRadius: 5)
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  onCreatePressed() async {
    if (!readyToFinishChallenge(true)) {
      SnackBarUtils.showSnackBar(
        context,
        AppLocalizations.of(context).pleaseFillUpAllTheCellsProperly,
      );
      return;
    }

    bool challengingOneFriend = _challengeTarget == ChallengeTarget.FRIENDS &&
        (_selectedFriends?.length ?? 0) == 1;
    final String groupId =
        challengingOneFriend ? _selectedFriends[0].groupId : null;

    Challenge challenge = Challenge(
      groupId: groupId,
      motivation: _motivationController.value.text,
      name: _challengeNameController.value.text,
      expiryDate: DateTime.now().millisecondsSinceEpoch ~/ 1000 +
          Duration.secondsPerDay *
              ArabicUtils.stringToNumber(
                  _expiresAfterDayNumController.value.text),
      subChallenges: _subChallenges,
    );

    try {
      if (_challengeTarget == ChallengeTarget.SELF) {
        await ServiceProvider.challengesService.addPersonalChallenge(
            AddChallengeRequestBody(challenge: challenge));
      } else {
        if (challengingOneFriend) {
          await ServiceProvider.challengesService
              .addGroupChallenge(AddChallengeRequestBody(challenge: challenge));
        } else {
          await ServiceProvider.challengesService.addFriendsChallenge(
              AddFriendsChallengeRequestBody(
                  challenge: challenge,
                  friendsIds: _selectedFriends
                      .map((friend) => friend.userId)
                      .toList()));
        }
      }
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
        context,
        e.error,
      );
      return;
    }

    SnackBarUtils.showSnackBar(
      context,
      AppLocalizations.of(context).challengeHasBeenAddedSuccessfully,
      color: Colors.green.shade400,
    );
    Navigator.of(context).pop();
  }

  bool readyToFinishChallenge(bool showWarnings) {
    if (_challengeTarget == ChallengeTarget.FRIENDS &&
        (_selectedFriends?.length ?? 0) == 0) {
      return false;
    }
    if (_subChallenges.length == 0) {
      return false;
    }

    if (!validateMotivation()) {
      return false;
    }

    if (!validateChallengeName(showWarnings)) {
      return false;
    }

    if (!validateExpiresAfterDaysNum(showWarnings)) {
      return false;
    }

    if (!_subChallengesValid) {
      return false;
    }

    return true;
  }
}
