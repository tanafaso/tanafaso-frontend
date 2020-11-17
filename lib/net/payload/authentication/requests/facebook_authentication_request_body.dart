import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class FacebookAuthenticationRequestBody
    extends RequestBodyBase<FacebookAuthenticationRequestBody> {
  final String token;
  final String facebookUserId;

  FacebookAuthenticationRequestBody(
      {@required this.token, @required this.facebookUserId});

  @override
  Map<String, dynamic> toJson() =>
      {'token': token, 'facebookUserId': facebookUserId};
}
