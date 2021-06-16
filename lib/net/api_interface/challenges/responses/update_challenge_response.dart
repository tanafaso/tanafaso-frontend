import '../../response_base.dart';

class UpdateChallengeResponse extends ResponseBase {
  static UpdateChallengeResponse fromJson(Map<String, dynamic> json) {
    UpdateChallengeResponse response = new UpdateChallengeResponse();
    response.setError(json);
    return response;
  }
}
