import 'dart:convert';
import 'dart:io';

import 'package:azkar/api_routes.dart';
import 'package:azkar/payload/authentication/requests/facebook_authentication_request.dart';
import 'package:azkar/payload/response_error.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'payload/authentication/responses/facebook_authentication_response.dart';

class Authentication {

  static var _facebookAccessToken;

  static Future<FacebookAuthenticationResponse> loginWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final facebookGraphApiResponse = await _facebookLogin.logIn(['email']);

    FacebookAuthenticationResponse facebookAuthenticationResponse;
    switch (facebookGraphApiResponse.status) {
      case FacebookLoginStatus.loggedIn:
        _facebookAccessToken = facebookGraphApiResponse.accessToken.token;

        final http.Response apiResponse = await http.put(
            Uri.http(ApiRoutes.BASE_URL, ApiRoutes.LOGIN_WITH_FACEBOOK),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(new FacebookAuthenticationRequest(
              facebookUserId: facebookGraphApiResponse.accessToken.userId,
              token: facebookGraphApiResponse.accessToken.token,
            ).toJson()));

        facebookAuthenticationResponse =
            FacebookAuthenticationResponse.fromJson(
                jsonDecode(apiResponse.body));
        if (facebookAuthenticationResponse.error.error_message == null) {
          final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
          final _storage = FlutterSecureStorage();
          await _storage.write(key: 'jwtToken', value: jwtToken);
        }
        return new Future.value(facebookAuthenticationResponse);
      case FacebookLoginStatus.cancelledByUser:
        facebookAuthenticationResponse.error = new Error("Cancelled by user.");
        return new Future.value(facebookAuthenticationResponse);
      case FacebookLoginStatus.error:
        facebookAuthenticationResponse.error =
            new Error("Facebook login error.");
        return new Future.value(facebookAuthenticationResponse);
      default:
        facebookAuthenticationResponse.error = new Error("Internal Error");
        return new Future.value(facebookAuthenticationResponse);
    }
  }

  static get facebookAccessToken => _facebookAccessToken;
}
