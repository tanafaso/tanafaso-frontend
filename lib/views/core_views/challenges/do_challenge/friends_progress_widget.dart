import 'package:azkar/models/challenge.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:flutter/material.dart';

class FriendsProgressWidget extends StatelessWidget {
  final Challenge challenge;
  final List<String> challengedUsersIds;
  final List<String> challengedUsersFullNames;

  FriendsProgressWidget({
    @required this.challenge,
    @required this.challengedUsersIds,
    @required this.challengedUsersFullNames,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        shrinkWrap: true,
        itemCount: challengedUsersIds.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    getFriendProgressOnChallengeIcon(challengedUsersIds[index]),
              ),
              Text(challengedUsersFullNames[index]),
              Visibility(
                visible: challengedUsersIds[index] == challenge?.creatingUserId,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(AppLocalizations.of(context).challengeCreator),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getFriendProgressOnChallengeIcon(String userId) {
    if (userId == null) {
      return Container();
    }

    if (challenge.usersFinished
        .any((userFinished) => userFinished == userId)) {
      return Icon(
        Icons.done_outline,
        size: 15,
        color: Colors.green,
      );
    }

    if (challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        size: 15,
        color: Colors.red,
      );
    }

    return Icon(
      Icons.not_started,
      size: 15,
      color: Colors.yellow,
    );
  }
}
