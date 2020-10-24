import 'dart:io';

import 'package:azkar/net/api_routes.dart';
import 'package:azkar/net/authentication.dart';
import 'package:http/http.dart' as http;

class ApiCaller {
  static Future<http.Response> get(ApiRoute route) async {
    String jwtToken = await Authentication.getJwtToken();

    return await http.get(
      Uri.http(ApiRoutesUtil.apiRouteToString(ApiRoute.BASE_URL),
          ApiRoutesUtil.apiRouteToString(route)),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: jwtToken
      },
    );
  }
}