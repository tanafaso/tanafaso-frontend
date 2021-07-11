import 'package:azkar/models/azkar_challenge.dart';
import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class UpdateAzkarChallengeRequestBody extends RequestBodyBase {
  final AzkarChallenge challenge;

  UpdateAzkarChallengeRequestBody({@required this.challenge});

  @override
  Map<String, dynamic> toJson() => {'newChallenge': challenge.toJson()};
}
