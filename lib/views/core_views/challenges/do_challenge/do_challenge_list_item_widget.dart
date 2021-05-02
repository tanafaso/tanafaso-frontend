import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';

typedef SubChallengeChangedCallback = void Function(
    SubChallenge newSubChallenge);

class DoChallengeSubChallengeListItemWidget extends StatefulWidget {
  final SubChallenge subChallenge;
  final SubChallengeChangedCallback callback;

  // Only use to check if the challenge is expired, since other data may change
  // and will not be consistent.
  final Challenge challenge;

  DoChallengeSubChallengeListItemWidget(
      {@required this.subChallenge,
      @required this.callback,
      @required this.challenge});

  @override
  _DoChallengeSubChallengeListItemWidgetState createState() =>
      _DoChallengeSubChallengeListItemWidgetState();
}

class _DoChallengeSubChallengeListItemWidgetState
    extends State<DoChallengeSubChallengeListItemWidget>
    with TickerProviderStateMixin {
  Color buttonColor;
  int initialRepetitions;

  @override
  void initState() {
    initialRepetitions = widget.subChallenge.repetitions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (buttonColor == null) {
      buttonColor = widget.subChallenge.done()
          ? Colors.green
          : Theme.of(context).buttonColor;
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.subChallenge.done()) {
          return;
        }
        if (widget.challenge.deadlinePassed()) {
          SnackBarUtils.showSnackBar(
            context,
            AppLocalizations.of(context)
                .theDeadlineHasAlreadyPassedForThisChallenge,
          );
          Navigator.of(context).pop();
          return;
        }
        setState(() {
          buttonColor = Colors.green;
          widget.subChallenge.repetitions -= 1;
          widget.callback.call(widget.subChallenge);
        });
      },
      onTapUp: (_) {
        if (widget.subChallenge.repetitions != 0) {
          setState(() {
            buttonColor = Theme.of(context).buttonColor;
          });
        }
      },
      child: Card(
        color: buttonColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.subChallenge.zekr.zekr,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getRepetitionsTextConditionally(),
            ),
            LinearProgressIndicator(
              minHeight: 10,
              color: Colors.white,
              backgroundColor: Colors.green,
              value: initialRepetitions == 0
                  ? 1
                  : widget.subChallenge.repetitions.toDouble() /
                      initialRepetitions.toDouble(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRepetitionsTextConditionally() {
    if (widget.subChallenge.repetitions == 0) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.done_outline),
          ),
          Text(
            AppLocalizations.of(context).youHaveFinishedReadingIt,
          ),
        ],
      );
    }

    return Text(
      '${AppLocalizations.of(context).theRemainingRepetitions}: ${ArabicUtils.englishToArabic(widget.subChallenge.repetitions.toString())}',
    );
  }
}
