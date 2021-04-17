import 'package:azkar/main.dart';
import 'package:azkar/net/payload/response_base.dart';
import 'package:flutter/material.dart';

class SnapshotUtils {
  static Widget getErrorWidget(BuildContext context,
      AsyncSnapshot<ResponseBase> snapshot) {
    if ((snapshot?.data?.error?.errorMessage?.length ?? 0) != 0) {
      return Text(
          '${AppLocalizations
              .of(context)
              .error}: ${snapshot.data.error.errorMessage}');
    } else {
      return Text(
          AppLocalizations
              .of(context)
              .pleaseConnectToInternetAndTryAgain);
    }
  }
}
