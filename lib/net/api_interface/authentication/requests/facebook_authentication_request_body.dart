
import '../../request_base.dart';

class FacebookAuthenticationRequestBody extends RequestBodyBase {
  final String token;
  final String facebookUserId;

  FacebookAuthenticationRequestBody(
      {required this.token, required this.facebookUserId});

  @override
  Map<String, dynamic> toJson() =>
      {'token': token, 'facebookUserId': facebookUserId};
}
