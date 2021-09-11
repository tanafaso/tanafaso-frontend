import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_azkar_challenge_in_group_request.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_azkar_challenge_request_body.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_azkar/selected_azkar_widget.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/selected_friends_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

// ignore: must_be_immutable
class CreateAzkarChallengeScreen extends StatefulWidget {
  List<Friend> initiallySelectedFriends;
  List<SubChallenge> initiallySelectedSubChallenges;
  String initiallyChosenName;
  String initiallyChosenMotivation;

  CreateAzkarChallengeScreen({
    this.initiallySelectedFriends = const [],
    this.initiallySelectedSubChallenges = const [],
    this.initiallyChosenName = "",
    this.initiallyChosenMotivation = "",
  });

  @override
  _CreateAzkarChallengeScreenState createState() =>
      _CreateAzkarChallengeScreenState();
}

class _CreateAzkarChallengeScreenState
    extends State<CreateAzkarChallengeScreen> {
  TextEditingController _challengeNameController;
  String _lastChallengeName = '';
  TextEditingController _motivationController;
  List<SubChallenge> _subChallenges;
  bool _subChallengesValid;
  List<Friend> _selectedFriends;
  ButtonState progressButtonState;
  int _expiresAfterHoursNum;
  ScrollController pageScrollController;

  initChallengeNameController() {
    _lastChallengeName = widget.initiallyChosenName;
    _challengeNameController =
        TextEditingController(text: widget.initiallyChosenName);
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

  bool validateMotivation() {
    final String motivation = _motivationController.value.text;
    // Note: Characters function is used here so as to count the actual number
    // of runes and not only the number of UTF-16 code points, because our
    // use-case with arabic language, there are some letters with tashkeel that
    // can only be represented in UTF-8 in 4 bytes.
    if (motivation.characters.length > 200) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    initChallengeNameController();
    _subChallenges = widget.initiallySelectedSubChallenges;
    _motivationController =
        TextEditingController(text: widget.initiallyChosenMotivation);
    _subChallengesValid = _subChallenges.length > 0;
    _selectedFriends = widget.initiallySelectedFriends;
    progressButtonState = ButtonState.idle;
    _expiresAfterHoursNum = 24;

    pageScrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قراءة أذكار"),
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
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      controller: pageScrollController,
                      children: [
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
                                  autofocus:
                                      (widget.initiallyChosenName?.length ??
                                              0) ==
                                          0,
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
                        SelectedFriendsWidget(
                          scrollController: pageScrollController,
                          initiallySelectedFriends:
                              widget.initiallySelectedFriends,
                          onSelectedFriendsChanged: (newFriends) {
                            setState(() {
                              _selectedFriends = newFriends;
                            });
                          },
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
                              Row(children: [
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
                              ]),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: new TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        new TextSpan(
                                          text: 'التحدي ينتهي بعد',
                                        ),
                                        new TextSpan(
                                            text:
                                                '  ${ArabicUtils.englishToArabic(_expiresAfterHoursNum.toString())}  ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            )),
                                        new TextSpan(
                                          text: 'ساعات.',
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              Slider(
                                value: _expiresAfterHoursNum.toDouble(),
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: Theme.of(context).primaryColor,
                                min: 1,
                                max: 24,
                                divisions: 24,
                                onChanged: (value) => setState(() =>
                                    _expiresAfterHoursNum = value.toInt()),
                                label: "$_expiresAfterHoursNum",
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
                                  maxLength: 200,
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
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                          child: !readyToFinishChallenge(false)
                              ? getNotReadyButton()
                              : getReadyButton(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget getNotReadyButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ButtonTheme(
        height: 50,
        // ignore: deprecated_member_use
        child: FlatButton(
          color: Colors.grey,
          onPressed: () async => onCreatePressed(),
          child: Center(
              child: Text(
            AppLocalizations.of(context).addNotReady,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget getReadyButton() {
    return ProgressButton.icon(
      textStyle: TextStyle(
        color: Colors.black,
      ),
      iconedButtons: {
        ButtonState.idle: IconedButton(
            // text: AppLocalizations.of(context).add,
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.white,
              size: 30,
            ),
            color: Colors.green.shade300),
        ButtonState.loading: IconedButton(
            text: AppLocalizations.of(context).sending,
            color: Colors.yellow.shade200),
        ButtonState.fail: IconedButton(
            text: AppLocalizations.of(context).failed,
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: AppLocalizations.of(context).login,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: onProgressButtonClicked,
      state: progressButtonState,
    );
  }

  void onProgressButtonClicked() {
    switch (progressButtonState) {
      case ButtonState.idle:
        setState(() {
          progressButtonState = ButtonState.loading;
        });

        onCreatePressed();
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        break;
      case ButtonState.fail:
        progressButtonState = ButtonState.idle;
        break;
    }
    setState(() {
      progressButtonState = progressButtonState;
    });
  }

  onCreatePressed() async {
    if (!readyToFinishChallenge(true)) {
      SnackBarUtils.showSnackBar(
        context,
        AppLocalizations.of(context).pleaseFillUpAllTheCellsProperly,
      );
      return;
    }

    bool challengingOneFriend = (_selectedFriends?.length ?? 0) == 1;
    final String groupId =
        challengingOneFriend ? _selectedFriends[0].groupId : null;

    AzkarChallenge challenge = AzkarChallenge(
      groupId: groupId,
      motivation: _motivationController.value.text,
      name: _challengeNameController.value.text,
      expiryDate: DateTime.now().millisecondsSinceEpoch ~/ 1000 +
          Duration.secondsPerHour * _expiresAfterHoursNum,
      subChallenges: _subChallenges,
    );

    try {
      if (challengingOneFriend) {
        await ServiceProvider.challengesService.addGroupChallenge(
            AddAzkarChallengeInGroupRequest(challenge: challenge));
      } else {
        await ServiceProvider.challengesService.addAzkarChallenge(
            AddAzkarChallengeRequestBody(
                challenge: challenge,
                friendsIds:
                    _selectedFriends.map((friend) => friend.userId).toList()));
      }
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
        context,
        e.errorStatus.errorMessage,
      );
      setState(() {
        progressButtonState = ButtonState.fail;
      });
      return;
    }

    setState(() {
      progressButtonState = ButtonState.success;
    });

    SnackBarUtils.showSnackBar(
      context,
      AppLocalizations.of(context).challengeHasBeenAddedSuccessfully,
      color: Colors.green.shade400,
    );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => HomePage(
                  initiallySelectedTopicType: TopicType.CHALLENGES,
                )),
        (_) => false);
  }

  bool readyToFinishChallenge(bool showWarnings) {
    if ((_selectedFriends?.length ?? 0) == 0) {
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

    if (!_subChallengesValid) {
      return false;
    }

    return true;
  }
}
