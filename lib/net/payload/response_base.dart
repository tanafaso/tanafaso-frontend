import 'package:flutter/material.dart';

import 'response_error.dart';

abstract class ResponseBase {
  Error error;

  @protected
  setError(Map<String, dynamic> json) {
    error = new Error((json['error'] ?? const {})['message']);
  }

  void setErrorMessage(String errorMessage) {
    error = Error(errorMessage);
  }

  bool hasError() {
    return error?.errorMessage?.isNotEmpty ?? false;
  }
}
