import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/user_group.dart';
import 'package:flutter/cupertino.dart';

class User {
  String email;
  String id;
  String username;
  String firstName;
  String lastName;
  List<UserGroup> userGroups;
  List<Challenge> personalChallenges;

  User({
    @required this.email,
    @required this.id,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.userGroups,
    @required this.personalChallenges,
  });

  int getFinishedChallengesCount() {
    int totalScore = 0;
    for (UserGroup userGroup in userGroups) {
      totalScore += userGroup.totalScore;
    }
    for (Challenge challenge in personalChallenges) {
      totalScore += challenge.done() ? 1 : 0;
    }
    return totalScore;
  }
}
