import 'package:azkar/payload/response_error.dart';

abstract class ResponseBase<T> {
  T _data;
  Error _error;

  set data(T value) {
    _data = value;
  }

  set error(Error value) {
    _error = value;
  }

  Error get error => _error;

  T get data => _data;
}
