import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/request_base.dart';
import 'package:flutter/cupertino.dart';

class AddFriendsChallengeRequestBody extends RequestBodyBase {
  Challenge challenge;
  List<String> friendsIds;

  AddFriendsChallengeRequestBody({
    @required this.challenge,
    @required this.friendsIds,
  });

  @override
  Map<String, dynamic> toJson() => {
        'challenge': challenge.toJson(),
        'friendsIds': friendsIds,
      };
}
