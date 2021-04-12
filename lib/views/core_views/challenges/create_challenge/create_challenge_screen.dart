import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/models/zekr.dart';
import 'package:azkar/net/payload/challenges/requests/add_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/responses/add_challenge_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend_screen.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_zekr_screen.dart';
import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatefulWidget {
  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

enum ChallengeTarget { SELF, FRIEND }

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  static const int DEFAULT_ORIGINAL_REPETITIONS = 1;

  ChallengeTarget _challengeTarget = ChallengeTarget.FRIEND;
  Friend _selectedFriend;
  List<SubChallenge> _subChallenges = [];
  bool _motivateFriend = false;
  TextEditingController _challengeNameController;
  String _lastChallengeName = '';
  TextEditingController _motivationController;
  String _lastMotivation = '';
  TextEditingController _expiresAfterDayNumController;
  String _lastExpiresAfterDayNum = '1';
  List<TextEditingController> _repetitionsControllers = [];

  initChallengeNameController() {
    _challengeNameController = TextEditingController(text: _lastChallengeName);
    _challengeNameController.addListener(() {
      if (_lastChallengeName == _challengeNameController.value.text) {
        return;
      }
      _lastChallengeName = _challengeNameController.value.text;
      validateChallengeName(true);
    });
  }

  bool validateChallengeName(bool showWarning) {
    final String newChallengeName = _challengeNameController.value.text;
    if (newChallengeName.isEmpty) {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).nameShouldNotBeEmpty)));
      }
      return false;
    }
    return true;
  }

  initMotivationController() {
    _motivationController = TextEditingController(text: _lastMotivation);

    _motivationController.addListener(() {
      if (_lastMotivation == _motivationController.value.text) {
        return;
      }
      _lastMotivation = _motivationController.value.text;
      validateMotivation(true);
    });
  }

  bool validateMotivation(bool showWarning) {
    final String newMotivation = _motivationController.value.text;
    if (newMotivation.isEmpty) {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context).motivationShouldNotBeEmpty)));
      }
      return false;
    }
    return true;
  }

  bool validateRepetition(String repetition, bool showWarning) {
    int repetitionsNum = 0;
    try {
      repetitionsNum = int.parse(repetition);
    } on FormatException {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)
                .repetitionsMustBeANumberFrom1to100)));
      }
      return false;
    }
    if (repetitionsNum <= 0) {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context).repetitionsMustBeMoreThan0)));
      }
      return false;
    }

    if (repetitionsNum > 100) {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)
                .repetitionsMustBeLessThanOrEqual100)));
      }
      return false;
    }
    return true;
  }

  initExpiresAfterDayNumController() {
    _expiresAfterDayNumController = TextEditingController(text: '1');
    _expiresAfterDayNumController.addListener(() {
      if (_lastExpiresAfterDayNum == _expiresAfterDayNumController.value.text) {
        return;
      }
      _lastExpiresAfterDayNum = _expiresAfterDayNumController.value.text;
      validateExpiresAfterDaysNum(true);
    });
  }

  bool validateExpiresAfterDaysNum(bool showWarning) {
    final String newExpiresAfterDayNum =
        _expiresAfterDayNumController.value.text;

    int newExpiresAfterDaysNumInt = 0;
    try {
      newExpiresAfterDaysNumInt = int.parse(newExpiresAfterDayNum);
    } on FormatException {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context).daysMustBeANumberFrom1to100)));
      }
      return false;
    }
    if (newExpiresAfterDaysNumInt <= 0) {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).daysMustBeMoreThan0)));
      }
      return false;
    }

    if (newExpiresAfterDaysNumInt > 100) {
      if (showWarning) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context).daysMustBeLessThanOrEqual100)));
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.grading),
                                ),
                                Text(
                                  '${AppLocalizations.of(context).iWantTo} ...',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            RadioListTile<ChallengeTarget>(
                              title: Text(
                                  AppLocalizations.of(context).challengeMyself),
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
                              title: Text(AppLocalizations.of(context)
                                  .challengeAFriend),
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
                                      shape: MaterialStateProperty.resolveWith(
                                          (_) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)))),
                                  onPressed: () async {
                                    Friend selectedFriend =
                                        await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectFriendScreen()))
                                            as Friend;
                                    if (selectedFriend != null) {
                                      setState(() {
                                        _selectedFriend = selectedFriend;
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
                                  Zekr selectedZekr = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectZekrScreen())) as Zekr;
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
                                              int.parse(controller.value.text);
                                        }
                                      });
                                      _repetitionsControllers.add(controller);
                                    });
                                  }
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Text(
                                        AppLocalizations.of(context).addZekr,
                                        style:
                                            Theme.of(context).textTheme.button,
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.drive_file_rename_outline),
                                ),
                                Text(
                                  AppLocalizations.of(context).challengeName,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.date_range),
                                ),
                                Text(
                                  AppLocalizations.of(context).deadline,
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Row(
                                children: [
                                  Icon(Icons.directions_run),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context).motivation,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              value: _motivateFriend,
                              onChanged: (value) {
                                setState(() {
                                  _motivateFriend = !_motivateFriend;
                                });
                              },
                            ),
                            Visibility(
                              visible: _motivateFriend,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    alignLabelWithHint: true,
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.teal)),
                                  ),
                                  controller: _motivationController,
                                ),
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
            // ignore: deprecated_member_use
          ),
        )),
      ),
    );
  }

  onCreatePressed() async {
    if (!readyToFinishChallenge(true)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context).pleaseFillUpAllTheCellsProperly)));
      return;
    }

    final String groupId = _challengeTarget == ChallengeTarget.FRIEND
        ? _selectedFriend.groupId
        : null;

    Challenge challenge = Challenge(
      groupId: groupId,
      motivation: _motivationController.value.text,
      name: _challengeNameController.value.text,
      expiryDate: DateTime.now().millisecondsSinceEpoch +
          Duration.millisecondsPerDay *
              int.parse(_expiresAfterDayNumController.value.text),
      subChallenges: _subChallenges,
    );

    AddChallengeRequestBody requestBody = AddChallengeRequestBody(
      challenge: challenge,
    );

    AddChallengeResponse response;
    if (_challengeTarget == ChallengeTarget.SELF) {
      response = await ServiceProvider.challengesService
          .addPersonalChallenge(requestBody);
    } else {
      response = await ServiceProvider.challengesService
          .addGroupChallenge(requestBody);
    }

    if (response.hasError()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.errorMessage)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(AppLocalizations.of(context).challengeHasBeenAddedSuccessfully),
      backgroundColor: Colors.green.shade400,
    ));
    Navigator.of(context).pop();
  }

  bool readyToFinishChallenge(bool showWarnings) {
    if (_challengeTarget == ChallengeTarget.FRIEND && _selectedFriend == null) {
      return false;
    }
    if (_subChallenges.length == 0) {
      return false;
    }

    if (!validateChallengeName(showWarnings) ||
        !validateExpiresAfterDaysNum(showWarnings)) {
      return false;
    }

    if (_motivateFriend && !validateMotivation(showWarnings)) {
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
    String text = _selectedFriend == null
        ? AppLocalizations.of(context).noFriendSelected
        : '${AppLocalizations.of(context).youWillChallenge}: ${_selectedFriend.name}';
    Color color = _selectedFriend == null ? Colors.pink : Colors.black;
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700, color: color),
    );
  }

  getSelectFriendTextConditionally() {
    final String text = _selectedFriend == null
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
      style: TextStyle(fontWeight: FontWeight.w700, color: color),
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
              elevation: 5,
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
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
