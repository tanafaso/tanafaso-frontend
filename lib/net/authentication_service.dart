import 'dart:convert';
import 'dart:io';

import 'package:azkar/net/api_routes.dart';
import 'package:azkar/net/payload/authentication/requests/email_login_request.dart';
import 'package:azkar/net/payload/authentication/requests/email_registration_request.dart';
import 'package:azkar/net/payload/authentication/requests/email_verification_request.dart';
import 'package:azkar/net/payload/authentication/requests/facebook_authentication_request.dart';
import 'package:azkar/net/payload/authentication/responses/email_login_response.dart';
import 'package:azkar/net/payload/authentication/responses/email_registration_response.dart';
import 'package:azkar/net/payload/authentication/responses/email_verification_response.dart';
import 'package:azkar/net/payload/request_base.dart';
import 'package:azkar/net/payload/response_error.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../net/payload/authentication/responses/facebook_authentication_response.dart';

class AuthenticationService {
  static final String jwtTokenStorageKey = 'jwtToken';
  static final String facebookTokenStorageKey = 'facebookAccessToken';

  static Future<FacebookAuthenticationResponse> loginWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final facebookGraphApiResponse = await _facebookLogin.logIn(['email']);

    FacebookAuthenticationResponse facebookAuthenticationResponse;
    switch (facebookGraphApiResponse.status) {
      case FacebookLoginStatus.loggedIn:
        final _storage = FlutterSecureStorage();
        await _storage.write(key: facebookTokenStorageKey, value: facebookGraphApiResponse.accessToken.token);

        final http.Response apiResponse = await http.put(
            Uri.http(ApiRoutesUtil.apiRouteToString(ApiRoute.BASE_URL),
                ApiRoutesUtil.apiRouteToString(ApiRoute.LOGIN_WITH_FACEBOOK)),
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
        if (!facebookAuthenticationResponse.hasError()) {
          final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
          final _storage = FlutterSecureStorage();
          await _storage.write(key: jwtTokenStorageKey, value: jwtToken);
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

  static Future<EmailRegistrationResponse> signUp(
      EmailRegistrationRequest request) async {
    final http.Response apiResponse = await http.put(
      Uri.http(ApiRoutesUtil.apiRouteToString(ApiRoute.BASE_URL),
          ApiRoutesUtil.apiRouteToString(ApiRoute.REGISTER_WITH_EMAIL)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    return EmailRegistrationResponse.fromJson(jsonDecode(apiResponse.body));
  }

  static Future<EmailLoginResponse> login(EmailLoginRequest request) async {
    final http.Response apiResponse = await http.put(
      Uri.http(ApiRoutesUtil.apiRouteToString(ApiRoute.BASE_URL),
          ApiRoutesUtil.apiRouteToString(ApiRoute.LOGIN_WITH_EMAIL)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    EmailLoginResponse emailLoginResponse =
        EmailLoginResponse.fromJson(jsonDecode(apiResponse.body));

    if (!emailLoginResponse.hasError()) {
      final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
      final _storage = FlutterSecureStorage();
      await _storage.write(key: jwtTokenStorageKey, value: jwtToken);
    }
    return emailLoginResponse;
  }

  static Future<EmailVerificationResponse> verifyEmail(
      EmailVerificationRequest request) async {
    final http.Response apiResponse = await http.put(
      Uri.http(ApiRoutesUtil.apiRouteToString(ApiRoute.BASE_URL),
          ApiRoutesUtil.apiRouteToString(ApiRoute.VERIFY_EMAIL)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    return EmailVerificationResponse.fromJson(jsonDecode(apiResponse.body));
  }

  static Future<String> getJwtToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: jwtTokenStorageKey);
  }
}
