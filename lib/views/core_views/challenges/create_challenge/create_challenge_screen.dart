import 'dart:convert';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/models/zekr.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/requests/add_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/responses/get_azkar_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend_screen.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_zekr_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ChallengeTarget { SELF, FRIEND }

// ignore: must_be_immutable
class CreateChallengeScreen extends StatefulWidget {
  Friend selectedFriend;
  ChallengeTarget defaultChallengeTarget;

  CreateChallengeScreen(
      {this.selectedFriend,
      this.defaultChallengeTarget = ChallengeTarget.FRIEND});

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  static const int DEFAULT_ORIGINAL_REPETITIONS = 1;

  ChallengeTarget _challengeTarget = ChallengeTarget.FRIEND;
  List<SubChallenge> _subChallenges = [];
  TextEditingController _challengeNameController;
  String _lastChallengeName = '';
  TextEditingController _motivationController;
  TextEditingController _expiresAfterDayNumController;
  String _lastExpiresAfterDayNum = '١';
  List<TextEditingController> _repetitionsControllers = [];

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
    if (motivation.length > 100) {
      return false;
    }
    return true;
  }

  bool validateRepetition(String repetition, bool showWarning) {
    int repetitionsNum = 0;
    try {
      repetitionsNum = stringToNumber(repetition);
    } on FormatException {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
          context,
          AppLocalizations.of(context).repetitionsMustBeANumberFrom1to100,
        );
      }
      return false;
    }
    if (repetitionsNum <= 0) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
          context,
          AppLocalizations.of(context).repetitionsMustBeMoreThan0,
        );
      }
      return false;
    }

    if (repetitionsNum > 100) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
          context,
          AppLocalizations.of(context).repetitionsMustBeLessThanOrEqual100,
        );
      }
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
      newExpiresAfterDaysNumInt = stringToNumber(newExpiresAfterDayNum);
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

  int stringToNumber(String number) {
    try {
      return int.parse(number);
    } on FormatException {
      // Maybe it is in arabic?!.
      return ArabicUtils.arabicToEnglish(number);
    }
  }

  @override
  void initState() {
    initChallengeNameController();
    initMotivationController();
    initExpiresAfterDayNumController();
    _challengeTarget = widget.defaultChallengeTarget;

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
                                        .challengeAFriend),
                                  ],
                                ),
                                dense: false,
                                value: ChallengeTarget.FRIEND,
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
                          visible: _challengeTarget == ChallengeTarget.FRIEND,
                          child: Card(
                            child: Column(
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
                                      child: Icon(Icons.person),
                                    ),
                                    getSelectedFriendNameConditionally(),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.resolveWith(
                                                (states) => 10),
                                        shape:
                                            MaterialStateProperty.resolveWith(
                                                (_) => RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)))),
                                    onPressed: () async {
                                      Friendship friendship;
                                      try {
                                        friendship = await ServiceProvider
                                            .usersService
                                            .getFriends();
                                      } on ApiException catch (e) {
                                        SnackBarUtils.showSnackBar(
                                          context,
                                          e.error,
                                        );
                                        return;
                                      }
                                      Friend selectedFriend =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectFriendScreen(
                                                        friendship: friendship,
                                                      ))) as Friend;
                                      if (selectedFriend != null) {
                                        setState(() {
                                          widget.selectedFriend =
                                              selectedFriend;
                                        });
                                      }
                                    },
                                    child: getSelectFriendTextConditionally(),
                                  ),
                                ),
                              ],
                            ),
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
                                    child: Icon(Icons.list),
                                  ),
                                  getAzkarSelectedTitleConditionally(),
                                ],
                              ),
                              Visibility(
                                  visible: _subChallenges.length > 0,
                                  child: getSubChallenges()),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(8),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.resolveWith(
                                              (states) => 10),
                                      shape: MaterialStateProperty.resolveWith(
                                          (_) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)))),
                                  onPressed: () async {
                                    List<Zekr> azkar;
                                    try {
                                      http.Response apiResponse =
                                          await ApiCaller.get(
                                              route: Endpoint(
                                                  endpointRoute:
                                                      EndpointRoute.GET_AZKAR));
                                      GetAzkarResponse response =
                                          GetAzkarResponse.fromJson(jsonDecode(
                                              utf8.decode(
                                                  apiResponse.body.codeUnits)));
                                      azkar = response.azkar;
                                    } on ApiException catch (e) {
                                      SnackBarUtils.showSnackBar(
                                        context,
                                        e.error,
                                      );
                                      return;
                                    }
                                    // Remove already selected azkar
                                    azkar.removeWhere((zekr) =>
                                        _subChallenges.any((subChallenge) =>
                                            subChallenge.zekr.id == zekr.id));
                                    Zekr selectedZekr = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectZekrScreen(
                                                  azkar: azkar,
                                                ))) as Zekr;
                                    if ((selectedZekr.zekr?.length ?? 0) != 0) {
                                      setState(() {
                                        SubChallenge subChallenge = SubChallenge(
                                            zekr: selectedZekr,
                                            repetitions:
                                                DEFAULT_ORIGINAL_REPETITIONS);
                                        _subChallenges.add(subChallenge);
                                        TextEditingController controller =
                                            TextEditingController(
                                                text:
                                                    "$DEFAULT_ORIGINAL_REPETITIONS");
                                        controller.addListener(() {
                                          if (subChallenge.repetitions
                                                  .toString() ==
                                              controller.value.text) {
                                            return;
                                          }
                                          if (validateRepetition(
                                              controller.value.text, true)) {
                                            subChallenge.repetitions =
                                                stringToNumber(
                                                    controller.value.text);
                                          }
                                          setState(() {});
                                        });
                                        _repetitionsControllers.add(controller);
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        Padding(padding: EdgeInsets.all(8)),
                                        Text(
                                          AppLocalizations.of(context).addZekr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

    final String groupId = _challengeTarget == ChallengeTarget.FRIEND
        ? widget.selectedFriend.groupId
        : null;

    Challenge challenge = Challenge(
      groupId: groupId,
      motivation: _motivationController.value.text,
      name: _challengeNameController.value.text,
      expiryDate: DateTime.now().millisecondsSinceEpoch ~/ 1000 +
          Duration.secondsPerDay *
              stringToNumber(_expiresAfterDayNumController.value.text),
      subChallenges: _subChallenges,
    );

    AddChallengeRequestBody requestBody = AddChallengeRequestBody(
      challenge: challenge,
    );

    try {
      if (_challengeTarget == ChallengeTarget.SELF) {
        await ServiceProvider.challengesService
            .addPersonalChallenge(requestBody);
      } else {
        await ServiceProvider.challengesService.addGroupChallenge(requestBody);
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
    if (_challengeTarget == ChallengeTarget.FRIEND &&
        widget.selectedFriend == null) {
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

    for (TextEditingController repetitionsController
        in _repetitionsControllers) {
      if (!validateRepetition(repetitionsController.value.text, showWarnings)) {
        return false;
      }
    }

    return true;
  }

  Widget getSelectedFriendNameConditionally() {
    String text = widget.selectedFriend == null
        ? AppLocalizations.of(context).noFriendSelected
        : '${AppLocalizations.of(context).youWillChallenge}: ${widget.selectedFriend.firstName} ${widget.selectedFriend.lastName}';
    Color color = widget.selectedFriend == null ? Colors.pink : Colors.black;
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color),
    );
  }

  getSelectFriendTextConditionally() {
    final String text = widget.selectedFriend == null
        ? AppLocalizations.of(context).selectAFriend
        : AppLocalizations.of(context).changeSelectedFriend;
    return Text(
      text,
      style: Theme.of(context).textTheme.button,
    );
  }

  getAzkarSelectedTitleConditionally() {
    final String text = _subChallenges.length == 0
        ? AppLocalizations.of(context).noAzkarSelected
        : AppLocalizations.of(context).theSelectedAzkar;
    Color color = _subChallenges.length == 0 ? Colors.pink : Colors.black;
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color),
    );
  }

  getSubChallenges() {
    return Container(
      height: 310,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: _subChallenges.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return zekrItem(context, index);
          },
        ),
      ),
    );
  }

  zekrItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 2 * MediaQuery.of(context).size.width / 3,
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            _subChallenges[index].zekr.zekr,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 1),
                    )),
                    Text(
                      AppLocalizations.of(context).repetitions,
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
                            textDirection: TextDirection.ltr,
                            decoration: new InputDecoration(
                              alignLabelWithHint: true,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                            ),
                            // textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            controller: _repetitionsControllers[index],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 1),
                    )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _subChallenges.removeAt(index);
                        });
                      },
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
