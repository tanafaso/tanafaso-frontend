import 'package:azkar/models/challenge.dart';
import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class UpdateChallengeRequestBody extends RequestBodyBase {
  final Challenge challenge;

  UpdateChallengeRequestBody({@required this.challenge});

  @override
  Map<String, dynamic> toJson() => {'newChallenge': challenge.toJson()};
}
