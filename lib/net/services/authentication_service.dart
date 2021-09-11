import 'dart:convert';
import 'dart:io';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/authentication/requests/email_login_request_body.dart';
import 'package:azkar/net/api_interface/authentication/requests/email_registration_request_body.dart';
import 'package:azkar/net/api_interface/authentication/requests/facebook_authentication_request_body.dart';
import 'package:azkar/net/api_interface/authentication/requests/reset_password_request_body.dart';
import 'package:azkar/net/api_interface/authentication/responses/email_login_response.dart';
import 'package:azkar/net/api_interface/authentication/responses/email_registration_response.dart';
import 'package:azkar/net/api_interface/authentication/responses/facebook_authentication_response.dart';
import 'package:azkar/net/api_interface/authentication/responses/facebook_friends_response.dart';
import 'package:azkar/net/api_interface/authentication/responses/reset_password_response.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  static const int FACEBOOK_INVALID_OAUTH_TOKEN_ERROR_CODE = 190;
  static const int MAXIMUM_FRIENDS_USING_APP_COUNT = 100;

  // Returns true if authentication was successful.
  Future<void> loginWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    _facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;

    final facebookGraphApiResponse =
        await _facebookLogin.logIn(['email', 'user_friends']);

    switch (facebookGraphApiResponse.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken _facebookAccessToken =
            facebookGraphApiResponse.accessToken;
        await ServiceProvider.secureStorageService
            .setFacebookToken(_facebookAccessToken.token);
        await ServiceProvider.secureStorageService
            .setFacebookUserId(_facebookAccessToken.userId);

        await _loginWithFacebookAccessToken(_facebookAccessToken);
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw ApiException.withDefaultError();
      case FacebookLoginStatus.error:
        throw ApiException.withDefaultError();
      default:
        throw ApiException.withDefaultError();
    }
  }

  // Returns true if authentication was successful.
  Future<void> _loginWithFacebookAccessToken(
      FacebookAccessToken facebookAccessToken) async {
    final http.Response apiResponse = await http.put(
        Uri.https(
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.LOGIN_WITH_FACEBOOK))),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(new FacebookAuthenticationRequestBody(
          facebookUserId: facebookAccessToken.userId,
          token: facebookAccessToken.token,
        ).toJson()));

    FacebookAuthenticationResponse response =
        FacebookAuthenticationResponse.fromJson(
            jsonDecode(utf8.decode(apiResponse.body.codeUnits)));

    if (!response.hasError()) {
      final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
      await ServiceProvider.secureStorageService.setJwtToken(jwtToken);
    }
    if (response.hasError()) {
      throw new ApiException(response.error);
    }
  }

  Future<void> connectFacebook() async {
    final _facebookLogin = FacebookLogin();
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final facebookGraphApiResponse =
        await _facebookLogin.logIn(['email', 'user_friends']);

    switch (facebookGraphApiResponse.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken facebookAccessToken =
            facebookGraphApiResponse.accessToken;
        await ServiceProvider.secureStorageService
            .setFacebookToken(facebookAccessToken.token);
        await ServiceProvider.secureStorageService
            .setFacebookUserId(facebookAccessToken.userId);

        _connectFacebookWithFacebookAccessToken(facebookAccessToken);
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw ApiException.withDefaultError();
      case FacebookLoginStatus.error:
        throw ApiException.withDefaultError();
      default:
        throw ApiException.withDefaultError();
    }
  }

  Future<void> _connectFacebookWithFacebookAccessToken(
      FacebookAccessToken facebookAccessToken) async {
    final http.Response apiResponse = await ApiCaller.put(
        route: Endpoint(endpointRoute: EndpointRoute.CONNECT_FACEBOOK),
        requestBody: FacebookAuthenticationRequestBody(
          facebookUserId: facebookAccessToken.userId,
          token: facebookAccessToken.token,
        ));

    FacebookAuthenticationResponse response =
        FacebookAuthenticationResponse.fromJson(
            jsonDecode(utf8.decode(apiResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.error);
    }
  }

  Future<List<FacebookFriend>> getFacebookFriends() async {
    String facebookToken =
        await ServiceProvider.secureStorageService.getFacebookToken();
    String facebookUserId =
        await ServiceProvider.secureStorageService.getFacebookUserId();
    http.Response response = await http.get(Uri.https("graph.facebook.com",
        "v9.0/$facebookUserId/friends/", {'access_token': facebookToken}));
    if (response.statusCode == FACEBOOK_INVALID_OAUTH_TOKEN_ERROR_CODE) {
      throw ApiException.withDefaultError();
    }
    var responseJson = jsonDecode(utf8.decode(response.body.codeUnits));
    if ((responseJson['error'] ?? null) != null) {
      await connectFacebook();
      throw ApiException.withDefaultError();
    }

    return FacebookFriendsResponse.fromJson(responseJson).facebookFriends;
  }

  Future<void> signUp(EmailRegistrationRequestBody request) async {
    http.Response apiResponse;
    try {
      apiResponse = await http.put(
        Uri.https(
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.REGISTER_WITH_EMAIL_V2))),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );
    } catch (e) {
      throw ApiException.withDefaultError();
    }

    var response = EmailRegistrationResponse.fromJson(
        jsonDecode(utf8.decode(apiResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.error);
    }
  }

  Future<void> login(EmailLoginRequestBody request) async {
    http.Response apiResponse;
    try {
      apiResponse = await http.put(
        Uri.https(
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.LOGIN_WITH_EMAIL))),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );
    } catch (e) {
      print('Error: An exception while requesting:'
          '${ApiRoutesUtil.apiRouteToString(Endpoint(endpointRoute: EndpointRoute.LOGIN_WITH_EMAIL))} '
          'with stack trace: ${e.toString()}');
      throw ApiException.withDefaultError();
    }

    var response = EmailLoginResponse.fromJson(
        jsonDecode(utf8.decode(apiResponse.body.codeUnits)));

    if (!response.hasError()) {
      final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
      await ServiceProvider.secureStorageService.setJwtToken(jwtToken);
    } else {
      throw new ApiException(response.error);
    }
  }

  Future<void> resetPassword(String email) async {
    ResetPasswordRequestBody requestBody =
        ResetPasswordRequestBody(email: email);
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.RESET_PASSWORD),
        requestBody: requestBody);

    var response = ResetPasswordResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.error);
    }
  }
}
