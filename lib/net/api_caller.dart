import 'dart:convert';
import 'dart:io';

import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/request_base.dart';
import 'package:azkar/net/secure_storage_util.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiCaller {
  static Future<http.Response> get({@required Endpoint route}) async {
    return await ServiceProvider.httpClient.get(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.LOCAL_HOST_BASE_URL)),
          ApiRoutesUtil.apiRouteToString(route),
          route.requestParams),
      headers: await getHeaders(),
    );
  }

  static Future<http.Response> put(
      {@required Endpoint route, RequestBodyBase requestBody}) async {
    return await ServiceProvider.httpClient.put(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.LOCAL_HOST_BASE_URL)),
          ApiRoutesUtil.apiRouteToString(route)),
      headers: await getHeaders(),
      body: jsonEncode(requestBody?.toJson()),
    );
  }

  static Future<http.Response> post(
      {@required Endpoint route, RequestBodyBase requestBody}) async {
    return await ServiceProvider.httpClient.post(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.LOCAL_HOST_BASE_URL)),
          ApiRoutesUtil.apiRouteToString(route)),
      headers: await getHeaders(),
      body: jsonEncode(requestBody?.toJson()),
    );
  }

  static Future<Map<String, String>> getHeaders() async {
    String jwtToken = await SecureStorageUtil.getJwtToken();

    return <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: jwtToken
    };
  }
}
