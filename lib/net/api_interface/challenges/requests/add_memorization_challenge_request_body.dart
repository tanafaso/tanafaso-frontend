import 'package:azkar/net/api_interface/request_base.dart';
import 'package:flutter/cupertino.dart';

class AddMemorizationChallengeRequestBody extends RequestBodyBase {
  List<String> friendsIds;
  int expiryDate;
  int difficulty;
  int firstJuz;
  int lastJuz;
  int numberOfQuestions;

  AddMemorizationChallengeRequestBody({
    @required this.friendsIds,
    @required this.expiryDate,
    @required this.difficulty,
    @required this.firstJuz,
    @required this.lastJuz,
    @required this.numberOfQuestions,
  });

  @override
  Map<String, dynamic> toJson() => {
        'friendsIds': friendsIds,
        'expiryDate': expiryDate,
        'difficulty': difficulty,
        'firstJuz': firstJuz,
        'lastJuz': lastJuz,
        'numberOfQuestions': numberOfQuestions,
      };
}
