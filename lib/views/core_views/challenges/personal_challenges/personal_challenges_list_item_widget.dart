import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:flutter/material.dart';

class PersonalChallengesListItemWidget extends StatelessWidget {
  final Challenge challenge;

  PersonalChallengesListItemWidget({@required this.challenge});

  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getIconConditionally(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${AppLocalizations.of(context).name}:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text(
                    challenge.name,
                  ),
                ],
              ),
              Visibility(
                visible: (challenge?.motivation?.length ?? 0) != 0,
                child: Row(
                  children: [
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${AppLocalizations.of(context).motivation}:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(
                      challenge.motivation,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${AppLocalizations.of(context).deadline}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  getDeadlineText(context),
                ],
              ),
            ],
          ),
        ],
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
            '${AppLocalizations.of(context).endsAfterLessThan} $minutesLeft ${AppLocalizations.of(context).minutes}');
      }
      return Text(
          '${AppLocalizations.of(context).endsAfter} $minutesLeft ${AppLocalizations.of(context).minutes}');
    }
    return Text(
        '${AppLocalizations.of(context).endsAfter} ${challenge.hoursLeft()} ${AppLocalizations.of(context).hours}');
  }
}
