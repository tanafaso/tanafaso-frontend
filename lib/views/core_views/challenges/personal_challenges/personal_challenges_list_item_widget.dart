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
                    child: Text('Name:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                      child: Text(
                        'Motivation:',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                    child: Text(
                      'Deadline:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  getDeadlineText(),
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

  Widget getDeadlineText() {
    if (challenge.deadlinePassed()) {
      return Text('Passed');
    }
    int hoursLeft = challenge.hoursLeft();
    if (hoursLeft == 0) {
      int minutesLeft = challenge.minutesLeft();
      if (minutesLeft == 0) {
        return Text('Ends after less than $minutesLeft minutes');
      }
      return Text('Ends after $minutesLeft minutes');
    }
    return Text('Ends after ${challenge.hoursLeft()} hours');
  }
}
