import 'package:azkar/payload/response_base.dart';

class EmailVerificationResponse extends ResponseBase {
  static EmailVerificationResponse fromJson(Map<String, dynamic> json) {
    EmailVerificationResponse resposne = new EmailVerificationResponse();
    resposne.setError(json);
    return resposne;
  }
}
