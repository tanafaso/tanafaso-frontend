import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/response_base.dart';

class GetChallengeResponse extends ResponseBase {
  Challenge challenge;

  static GetChallengeResponse fromJson(Map<String, dynamic> json) {
    GetChallengeResponse response = new GetChallengeResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    response.challenge = Challenge.fromJson(json['data']);
    return response;
  }
}
