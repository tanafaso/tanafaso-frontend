import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class EmailRegistrationRequestBody
    extends RequestBodyBase<EmailRegistrationRequestBody> {
  final String email;
  final String password;
  final String name;

  EmailRegistrationRequestBody(
      {@required this.email, @required this.password, @required this.name});

  @override
  Map<String, dynamic> toJson() =>
      {'email': email, 'password': password, 'name': name};
}
