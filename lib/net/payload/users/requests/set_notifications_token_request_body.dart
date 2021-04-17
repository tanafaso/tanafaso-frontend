import 'package:azkar/net/payload/request_base.dart';
import 'package:flutter/cupertino.dart';

class SetNotificationsTokenRequestBody extends RequestBodyBase {
  String token;

  SetNotificationsTokenRequestBody({@required this.token});

  @override
  Map<String, dynamic> toJson() => {'token': token};
}
