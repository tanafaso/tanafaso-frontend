import 'package:azkar/payload/response_base.dart';

class EmailRegistrationResponse extends ResponseBase {
  static EmailRegistrationResponse fromJson(Map<String, dynamic> json) {
    EmailRegistrationResponse resposne = new EmailRegistrationResponse();
    resposne.setError(json);
    return resposne;
  }
}
