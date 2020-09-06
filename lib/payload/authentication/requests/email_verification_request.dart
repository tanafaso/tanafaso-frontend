import 'package:flutter/cupertino.dart';

class EmailVerificationRequest {
  final String email;
  final int pin;

  EmailVerificationRequest(
      {@required this.email, @required this.pin});

  Map<String, dynamic> toJson() =>
      {'email': email, 'pin': pin};
}
