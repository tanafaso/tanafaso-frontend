import 'package:azkar/main.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:flutter/material.dart';

typedef SubChallengeChangedCallback = void Function(
    SubChallenge newSubChallenge);

class DoChallengeSubChallengeListItemWidget extends StatefulWidget {
  final SubChallenge subChallenge;
  final SubChallengeChangedCallback callback;

  DoChallengeSubChallengeListItemWidget(
      {@required this.subChallenge, @required this.callback});

  @override
  _DoChallengeSubChallengeListItemWidgetState createState() =>
      _DoChallengeSubChallengeListItemWidgetState();
}

class _DoChallengeSubChallengeListItemWidgetState
    extends State<DoChallengeSubChallengeListItemWidget> {
  Color buttonColor;

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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: const Divider(
            //     color: Colors.grey,
            //     height: 0,
            //     thickness: 3,
            //     indent: 3,
            //     endIndent: 3,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getRepetitionsTextConditionally(),
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
      '${AppLocalizations.of(context).theRemainingRepetitions}: ${widget.subChallenge.repetitions}',
    );
  }
}
