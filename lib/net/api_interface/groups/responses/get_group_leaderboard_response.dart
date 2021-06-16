import 'package:azkar/models/user_score.dart';
import 'package:azkar/net/payload/response_base.dart';

class GetGroupLeaderboardResponse extends ResponseBase {
  List<UserScore> userScores;

  static GetGroupLeaderboardResponse fromJson(Map<String, dynamic> json) {
    GetGroupLeaderboardResponse response = new GetGroupLeaderboardResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    response.userScores = [];
    for (var userScoreJson in json['data']) {
      response.userScores.add(UserScore.fromJson(userScoreJson));
    }
    return response;
  }
}
