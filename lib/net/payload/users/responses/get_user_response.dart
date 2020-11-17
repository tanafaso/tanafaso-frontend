import 'package:azkar/models/user.dart';
import 'package:azkar/net/payload/response_base.dart';

class GetUserResponse extends ResponseBase {
  User user;

  static GetUserResponse fromJson(Map<String, dynamic> json) {
    GetUserResponse response = new GetUserResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }

    var data = json['data'];
    response.user = User(
        email: data['email'],
        id: data['id'],
        username: data['username'],
        name: data['name']);
    return response;
  }
}
