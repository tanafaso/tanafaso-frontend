import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/response_base.dart';

class GetChallengesResponse extends ResponseBase {
  List<Challenge> challenges;

  static GetChallengesResponse fromJson(Map<String, dynamic> json) {
    GetChallengesResponse response = new GetChallengesResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    response.challenges = [];
    for (var jsonChallenge in json['data']) {
      response.challenges.add(Challenge.fromJson(jsonChallenge));
    }
    return response;
  }
}
