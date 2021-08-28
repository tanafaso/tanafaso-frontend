import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/user_group.dart';
import 'package:flutter/cupertino.dart';

class User {
  String email;
  String id;
  String username;
  String firstName;
  String lastName;
  List<UserGroup> userGroups;
  List<AzkarChallenge> personalChallenges;

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
    for (AzkarChallenge challenge in personalChallenges) {
      totalScore += challenge.done() ? 1 : 0;
    }
    return totalScore;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    List<UserGroup> userGroups = [];
    for (var userGroupJson in json['userGroups']) {
      userGroups.add(UserGroup.fromJson(userGroupJson));
    }
    List<AzkarChallenge> personalChallenges = [];
    for (var personalChallengeJson in json['personalChallenges']) {
      personalChallenges.add(AzkarChallenge.fromJson(personalChallengeJson));
    }
    return User(
      email: json['email'],
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userGroups: userGroups,
      personalChallenges: personalChallenges,
    );
  }

  Map<String, dynamic> toJson() => {};
}
