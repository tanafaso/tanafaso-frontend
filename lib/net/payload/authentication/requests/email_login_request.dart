import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class EmailLoginRequest extends RequestBase<EmailLoginRequest>{
  final String email;
  final String password;

  EmailLoginRequest({@required this.email, @required this.password});

  @override
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
