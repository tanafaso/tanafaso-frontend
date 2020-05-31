import 'package:flutter/cupertino.dart';

class FacebookAuthenticationRequest {
  final String token;
  final String facebookUserId;

  FacebookAuthenticationRequest(
      {@required this.token, @required this.facebookUserId});

  Map<String, dynamic> toJson() =>
      {'token': token, 'facebookUserId': facebookUserId};
}
