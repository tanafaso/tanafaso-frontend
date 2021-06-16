import 'package:azkar/net/api_interface/status.dart';

class ApiException implements Exception {
  String error;

  ApiException(this.error);

  static ApiException withDefaultError() {
    return new ApiException(Status.getDefaultApiErrorStatus().errorMessage);
  }
}
