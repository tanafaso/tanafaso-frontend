import 'package:azkar/net/api_interface/request_base.dart';
import 'package:flutter/cupertino.dart';

class AddMeaningChallengeRequestBody extends RequestBodyBase {
  List<String> friendsIds;
  int expiryDate;

  AddMeaningChallengeRequestBody({
    @required this.friendsIds,
    @required this.expiryDate,
  });

  @override
  Map<String, dynamic> toJson() => {
        'friendsIds': friendsIds,
        'expiryDate': expiryDate,
      };
}
