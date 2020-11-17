import 'dart:convert';
import 'dart:io';

import 'package:azkar/net/authentication_service.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/request_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiCaller {
  static Future<http.Response> get(Endpoint route) async {
    return await http.get(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
          ApiRoutesUtil.apiRouteToString(route),
          route.requestParams),
      headers: await getHeaders(),
    );
  }

  static Future<http.Response> put(
      {@required Endpoint route, RequestBodyBase requestBody}) async {
    return await http.put(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
          ApiRoutesUtil.apiRouteToString(route)),
      headers: await getHeaders(),
      body: jsonEncode(requestBody?.toJson()),
    );
  }

  static Future<Map<String, String>> getHeaders() async {
    String jwtToken = await AuthenticationService.getJwtToken();

    return <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: jwtToken
    };
  }
}
