import 'package:azkar/payload/response_base.dart';
import 'package:azkar/payload/response_error.dart';

class FacebookAuthenticationResponse extends ResponseBase {
  static FacebookAuthenticationResponse fromJson(Map<String, dynamic> json) {
    FacebookAuthenticationResponse response =
        new FacebookAuthenticationResponse();
    response.setError(json);
    return response;
  }
}
