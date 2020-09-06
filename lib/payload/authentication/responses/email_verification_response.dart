import 'package:azkar/payload/response_base.dart';
import 'package:azkar/payload/response_error.dart';

class EmailVerificationResponse extends ResponseBase {
  static EmailVerificationResponse fromJson(Map<String, dynamic> json) {
    EmailVerificationResponse resposne =
        new EmailVerificationResponse();
    resposne.setError(json);
    return resposne;
  }
}
