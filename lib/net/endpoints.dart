import 'package:flutter/material.dart';

enum EndpointRoute {
  BASE_URL,
  LOGIN_WITH_FACEBOOK,
  REGISTER_WITH_EMAIL,
  VERIFY_EMAIL,
  LOGIN_WITH_EMAIL,
  GET_AZKAR,
  GET_CURRENT_USER_PROFILE,
  GET_USER_BY_USERNAME,
  ADD_FRIEND_BY_USERNAME,
  GET_FRIENDS
}

class Endpoint {
  final EndpointRoute endpointRoute;
  List<String> pathVariables = List.empty();
  Map<String, String> requestParams = Map<String, String>();

  Endpoint(
      {@required this.endpointRoute, this.pathVariables, this.requestParams});
}

class ApiRoutesUtil {
  static String apiRouteToString(Endpoint route) {
    switch (route.endpointRoute) {
      case EndpointRoute.BASE_URL:
        return 'localhost:8080';
      case EndpointRoute.LOGIN_WITH_FACEBOOK:
        return '/login/facebook';
      case EndpointRoute.REGISTER_WITH_EMAIL:
        return '/register/email';
      case EndpointRoute.VERIFY_EMAIL:
        return '/verify/email';
      case EndpointRoute.LOGIN_WITH_EMAIL:
        return '/login/email';
      case EndpointRoute.GET_AZKAR:
        return '/azkar';
      case EndpointRoute.GET_CURRENT_USER_PROFILE:
        return 'users/me';
      case EndpointRoute.GET_USER_BY_USERNAME:
        assert(route.requestParams.length == 1);
        return '/users';
      case EndpointRoute.ADD_FRIEND_BY_USERNAME:
        assert(route.pathVariables.length == 1);
        return '/friends/${route.pathVariables[0]}';
      case EndpointRoute.GET_FRIENDS:
        return '/friends';
      default:
        print('Route enum is not registered.');
    }
  }
}
