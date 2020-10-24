import 'package:azkar/payload/request_base.dart';
import 'package:flutter/cupertino.dart';

class FacebookAuthenticationRequest extends RequestBase<FacebookAuthenticationRequest> {
  final String token;
  final String facebookUserId;

  FacebookAuthenticationRequest(
      {@required this.token, @required this.facebookUserId});

  @override
  Map<String, dynamic> toJson() =>
      {'token': token, 'facebookUserId': facebookUserId};
}
