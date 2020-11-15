import '../../request_base.dart';
import 'package:flutter/cupertino.dart';

class EmailVerificationRequest extends RequestBase<EmailVerificationRequest> {
  final String email;
  final int pin;

  EmailVerificationRequest({@required this.email, @required this.pin});

  @override
  Map<String, dynamic> toJson() => {'email': email, 'pin': pin};
}
