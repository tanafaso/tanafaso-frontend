import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class EmailRegistrationRequest extends RequestBase<EmailRegistrationRequest>{
  final String email;
  final String password;
  final String name;

  EmailRegistrationRequest(
      {@required this.email, @required this.password, @required this.name});

  @override
  Map<String, dynamic> toJson() =>
      {'email': email, 'password': password, 'name': name};
}
