import 'package:azkar/payload/response_error.dart';

abstract class ResponseBase {
  Error error;

  setError(Map<String, dynamic> json) {
    error = new Error((json['error'] ?? const {})['message']);
  }

  bool hasError() {
    return error?.error_message?.isNotEmpty ?? false;
  }

}
