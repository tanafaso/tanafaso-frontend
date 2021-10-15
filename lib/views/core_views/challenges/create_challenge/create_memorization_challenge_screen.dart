import 'package:auto_size_text/auto_size_text.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_memorization_challenge_request_body.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/selected_friends_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class CreateMemorizationChallengeScreen extends StatefulWidget {
  final List<Friend> initiallySelectedFriends;
  final int initiallySelectedNumberOfQuestions;
  final int initiallySelectedDifficulty;
  final int initiallySelectedFirstJuz;
  final int initiallySelectedLastJuz;

  CreateMemorizationChallengeScreen({
    this.initiallySelectedFriends = const [],
    this.initiallySelectedNumberOfQuestions = 1,
    this.initiallySelectedDifficulty = 1,
    this.initiallySelectedFirstJuz = 28,
    this.initiallySelectedLastJuz = 30,
  });

  @override
  _CreateMemorizationChallengeScreenState createState() =>
      _CreateMemorizationChallengeScreenState();
}

class _CreateMemorizationChallengeScreenState
    extends State<CreateMemorizationChallengeScreen> {
  List<Friend> _selectedFriends;
  ButtonState progressButtonState;
  int _expiresAfterHoursNum;
  int _numberOfQuestions;
  int _difficulty;
  double _firstJuz;
  double _lastJuz;

  @override
  void initState() {
    super.initState();

    _selectedFriends = widget.initiallySelectedFriends;
    progressButtonState = ButtonState.idle;
    _expiresAfterHoursNum = 24;
    _numberOfQuestions = widget.initiallySelectedNumberOfQuestions;
    _firstJuz = widget.initiallySelectedFirstJuz * 1.0;
    _lastJuz = widget.initiallySelectedLastJuz * 1.0;
    _difficulty = widget.initiallySelectedDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'اختبار حفظ قرآن',
          style: TextStyle(fontSize: 30),
        ),
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
            thickness: 5,
            isAlwaysShown: true,
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
                          child: Column(children: [
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
                                  child: Icon(Icons.pie_chart),
                                ),
                                AutoSizeText(
                                  "أجزاء القرآن",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 20),
                                        children: [
                                          TextSpan(text: 'تحدي في الأجزاء من '),
                                          TextSpan(
                                              text: ArabicUtils.englishToArabic(
                                                  _firstJuz.toInt().toString()),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.black)),
                                          TextSpan(text: ' إلى '),
                                          TextSpan(
                                              text: ArabicUtils.englishToArabic(
                                                  _lastJuz.toInt().toString()),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values:
                                  RangeValues(_firstJuz * 1.0, _lastJuz * 1.0),
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              inactiveColor:
                                  Theme.of(context).colorScheme.primary,
                              min: 1,
                              max: 30,
                              divisions: 30,
                              onChanged: (newRange) {
                                setState(() {
                                  _firstJuz = newRange.start;
                                  _lastJuz = newRange.end;
                                });
                              },
                              labels: RangeLabels(
                                  ArabicUtils.englishToArabic(
                                      _firstJuz.toInt().toString()),
                                  ArabicUtils.englishToArabic(
                                      _lastJuz.toInt().toString())),
                            ),
                          ]),
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
                                    child: Icon(Icons.format_list_numbered),
                                  ),
                                  AutoSizeText(
                                    "عدد الأسئلة",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText.rich(TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: new TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      children: <TextSpan>[
                                        new TextSpan(
                                          text: 'عدد الأسئلة في التحدي: ',
                                        ),
                                        new TextSpan(
                                            text:
                                                '${ArabicUtils.englishToArabic(_numberOfQuestions.toString())}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            )),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              Slider(
                                value: _numberOfQuestions.toDouble(),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                inactiveColor:
                                    Theme.of(context).colorScheme.primary,
                                min: 1,
                                max: 10,
                                divisions: 10,
                                onChanged: (value) => setState(
                                    () => _numberOfQuestions = value.toInt()),
                                label:
                                    "${ArabicUtils.englishToArabic(_numberOfQuestions.toString())}",
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
                                    child: Icon(Icons.whatshot_rounded),
                                  ),
                                  AutoSizeText(
                                    "صعوبة التحدي",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: getDifficultyDescriptionWidget(),
                              ),
                              Slider(
                                value: _difficulty.toDouble(),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                inactiveColor:
                                    Theme.of(context).colorScheme.primary,
                                min: 1,
                                max: 3,
                                divisions: 3,
                                onChanged: (value) =>
                                    setState(() => _difficulty = value.toInt()),
                                label:
                                    "${ArabicUtils.englishToArabic(_difficulty.toString())}",
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
                                  AutoSizeText(
                                    AppLocalizations.of(context).deadline,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText.rich(TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: new TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      children: <TextSpan>[
                                        new TextSpan(
                                          text: 'التحدي ينتهي بعد',
                                        ),
                                        new TextSpan(
                                            text:
                                                '  ${ArabicUtils.englishToArabic(_expiresAfterHoursNum.toString())}  ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
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
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                inactiveColor:
                                    Theme.of(context).colorScheme.primary,
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

  Widget getDifficultyDescriptionWidget() {
    String description;
    if (_difficulty == 1) {
      description = '''- اسأل عن السورة
- اسأل عن الآية التالية
     ''';
    } else if (_difficulty == 2) {
      description = '''- اسأل عن السورة
- اسأل عن الآية التالية
- اسأل عن الجزء
- إسأل عن الآية السابقة
     ''';
    } else {
      description = '''- اسأل عن السورة
- اسأل عن الآية التالية
- اسأل عن الجزء
- إسأل عن الآية السابقة
- اسأل عن الربع
     ''';
    }

    return Row(
      children: [
        Text(
          description,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 20),
        ),
      ],
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

    try {
      await ServiceProvider.challengesService
          .addMemorizationChallenge(AddMemorizationChallengeRequestBody(
        friendsIds: _selectedFriends.map((friend) => friend.userId).toList(),
        expiryDate: DateTime.now().millisecondsSinceEpoch ~/ 1000 +
            Duration.secondsPerHour * _expiresAfterHoursNum,
        difficulty: _difficulty,
        numberOfQuestions: _numberOfQuestions,
        firstJuz: _firstJuz.toInt(),
        lastJuz: _lastJuz.toInt(),
      ));
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
    return true;
  }
}
