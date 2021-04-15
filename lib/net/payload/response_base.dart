import 'package:flutter/material.dart';

import 'status.dart';

abstract class ResponseBase {
  Status error;

  @protected
  setError(Map<String, dynamic> json) {
    error = new Status((json['status'] ?? const {})['code']);
  }

  void setErrorMessage(int errorCode) {
    error = Status(errorCode);
  }

  bool hasError() {
    return error?.code != Status.API_SUCCESS;
  }
}
