import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/payload/status.dart';
import 'package:flutter/material.dart';

class SnapshotUtils {
  static Widget getErrorWidget(
      BuildContext context, AsyncSnapshot<Object> snapshot) {
    String error;
    if (snapshot.error is ApiException) {
      error = (snapshot.error as ApiException).error;
    } else {
      error = Status.getDefaultApiErrorStatus().errorMessage;
    }
    return Text(error);
  }
}
