import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/request_base.dart';
import 'package:flutter/cupertino.dart';

class AddChallengeRequestBody extends RequestBodyBase {
  Challenge challenge;

  AddChallengeRequestBody({@required this.challenge});

  @override
  Map<String, dynamic> toJson() => {'challenge': challenge.toJson()};
}
