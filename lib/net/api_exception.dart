class ApiException implements Exception {
  String error;

  ApiException(this.error);
}
