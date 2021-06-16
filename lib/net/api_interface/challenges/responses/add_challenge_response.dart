import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/api_interface/response_base.dart';

class AddChallengeResponse extends ResponseBase {
  Challenge challenge;

  static AddChallengeResponse fromJson(Map<String, dynamic> json) {
    AddChallengeResponse response = new AddChallengeResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    response.challenge = Challenge.fromJson(json['data']);
    return response;
  }
}
