import 'package:azkar/models/friend.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_meaning_challenge_request_body.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/selected_friends_widget.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

// ignore: must_be_immutable
class CreateMeaningChallengeScreen extends StatefulWidget {
  List<Friend> initiallySelectedFriends;

  CreateMeaningChallengeScreen({
    this.initiallySelectedFriends = const [],
  });

  @override
  _CreateMeaningChallengeScreenState createState() =>
      _CreateMeaningChallengeScreenState();
}

class _CreateMeaningChallengeScreenState
    extends State<CreateMeaningChallengeScreen> {
  TextEditingController _expiresAfterHoursNumController;
  String _lastExpiresAfterHoursNum = '٢٤';
  List<Friend> _selectedFriends;
  ButtonState progressButtonState;
  int _numberOfWords;

  initExpiresAfterHoursNumController() {
    _expiresAfterHoursNumController = TextEditingController(text: '٢٤');
    _expiresAfterHoursNumController.addListener(() {
      if (_lastExpiresAfterHoursNum ==
          _expiresAfterHoursNumController.value.text) {
        return;
      }
      _lastExpiresAfterHoursNum = _expiresAfterHoursNumController.value.text;
      validateExpiresAfterHoursNum(true);
      setState(() {});
    });
  }

  bool validateExpiresAfterHoursNum(bool showWarning) {
    final String newExpiresAfterHoursNum =
        _expiresAfterHoursNumController.value.text;

    int newExpiresAfterHoursNumInt = 0;
    try {
      newExpiresAfterHoursNumInt =
          ArabicUtils.stringToNumber(newExpiresAfterHoursNum);
    } on FormatException {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
            context, AppLocalizations.of(context).hoursMustBeANumberFrom1to24);
      }
      return false;
    }
    if (newExpiresAfterHoursNumInt <= 0) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
            context, AppLocalizations.of(context).hoursMustBeMoreThan0);
      }
      return false;
    }

    if (newExpiresAfterHoursNumInt > 24) {
      if (showWarning) {
        SnackBarUtils.showSnackBar(
            context, AppLocalizations.of(context).hoursMustBeLessThanOrEqual24);
      }
      return false;
    }
    return true;
  }

  @override
  void initState() {
    initExpiresAfterHoursNumController();
    _selectedFriends = widget.initiallySelectedFriends;
    progressButtonState = ButtonState.idle;
    _numberOfWords = 3;

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
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      children: [
                        SelectedFriendsWidget(
                          initiallySelectedFriends:
                              widget.initiallySelectedFriends,
                          onSelectedFriendsChanged: (newFriends) {
                            setState(() {
                              _selectedFriends = newFriends;
                            });
                          },
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
                                                _expiresAfterHoursNumController,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).hours,
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
                                          child: NumberPicker(
                                            value: _numberOfWords,
                                            minValue: 0,
                                            maxValue: 100,
                                            step: 10,
                                            haptics: true,
                                            onChanged: (value) => setState(
                                                () => _numberOfWords = value),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).hours,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
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
      setState(() {
        progressButtonState = ButtonState.fail;
      });
      return;
    }

    try {
      await ServiceProvider.challengesService
          .addMeaningChallenge(AddMeaningChallengeRequestBody(
        friendsIds: _selectedFriends.map((friend) => friend.userId).toList(),
        expiryDate: DateTime.now().millisecondsSinceEpoch ~/ 1000 +
            Duration.secondsPerHour *
                ArabicUtils.stringToNumber(
                    _expiresAfterHoursNumController.value.text),
        numberOfWords: _numberOfWords,
      ));
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
        context,
        e.error,
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
    Navigator.of(context).pop();
  }

  bool readyToFinishChallenge(bool showWarnings) {
    if ((_selectedFriends?.length ?? 0) == 0) {
      return false;
    }

    if (!validateExpiresAfterHoursNum(showWarnings)) {
      return false;
    }

    return true;
  }
}
