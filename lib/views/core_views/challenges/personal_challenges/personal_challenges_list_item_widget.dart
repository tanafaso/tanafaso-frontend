import 'package:azkar/models/challenge.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_numbers_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:flutter/material.dart';

class PersonalChallengesListItemWidget extends StatelessWidget {
  final Challenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;

  PersonalChallengesListItemWidget(
      {@required this.challenge, @required this.challengeChangedCallback});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (challenge.deadlinePassed()) {
          SnackBarUtils.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .theDeadlineHasAlreadyPassedForThisChallenge);
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DoChallengeScreen(
                challenge: challenge,
                isPersonalChallenge: true,
                challengeChangedCallback: (changedChallenge) {
                  challengeChangedCallback.call(changedChallenge);
                })));
      },
      child: Card(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                getIconConditionally(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VerticalDivider(
                    width: 3,
                    color: Colors.black,
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          challenge.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: (challenge?.motivation?.length ?? 0) != 0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.directions_run),
                        ),
                        Text(
                          challenge.motivation,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !challenge.done(),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.alarm),
                        ),
                        getDeadlineText(context),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getIconConditionally() {
    if (challenge.done()) {
      return Icon(
        Icons.done_outline,
        color: Colors.green,
      );
    }
    if (challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
      );
    }
    return Icon(
      Icons.not_started,
      color: Colors.yellow,
    );
  }

  Widget getDeadlineText(BuildContext context) {
    if (challenge.deadlinePassed()) {
      return Text(AppLocalizations.of(context).passed);
    }
    int hoursLeft = challenge.hoursLeft();
    if (hoursLeft == 0) {
      int minutesLeft = challenge.minutesLeft();
      if (minutesLeft == 0) {
        return Text(
            '${AppLocalizations.of(context).endsAfterLessThan} ١ ${AppLocalizations.of(context).minute}');
      }
      return Text(
          '${AppLocalizations.of(context).endsAfter} ${ArabicNumbersUtils.englishToArabic(minutesLeft.toString())} ${AppLocalizations.of(context).minute}');
    }
    return Text(
        '${AppLocalizations.of(context).endsAfter} ${ArabicNumbersUtils.englishToArabic(challenge.hoursLeft().toString())} ${AppLocalizations.of(context).hour}');
  }
}
