import 'package:flutter/cupertino.dart';

class EmailLoginRequest {
  final String email;
  final String password;

  EmailLoginRequest({@required this.email, @required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
