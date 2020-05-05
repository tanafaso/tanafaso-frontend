import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Authentication {
  static final _facebookLogin = FacebookLogin();
  static var _facebookAccessToken;
  static Future<void> loginWithFacebook() async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final result = await _facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _facebookAccessToken = result.accessToken.token;
        // TODO: send to the backend
        break;
      case FacebookLoginStatus.cancelledByUser:
      case FacebookLoginStatus.error:
        break;
    }
  }

  static get facebookAccessToken => _facebookAccessToken;
}