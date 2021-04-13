import 'package:azkar/models/user_group.dart';
import 'package:flutter/cupertino.dart';

class User {
  String email;
  String id;
  String username;
  String firstName;
  String lastName;
  List<UserGroup> userGroups;

  User({
    @required this.email,
    @required this.id,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.userGroups,
  });

  int getFinishedChallengesCount() {
    int totalScore = 0;
    for (UserGroup userGroup in userGroups) {
      totalScore += userGroup.totalScore;
    }
    return totalScore;
  }
}
