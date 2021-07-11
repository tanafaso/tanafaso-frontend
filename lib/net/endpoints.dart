import 'dart:io' show Platform;

import 'package:flutter/material.dart';

enum EndpointRoute {
  BASE_URL,
  LOGIN_WITH_FACEBOOK,
  CONNECT_FACEBOOK,
  REGISTER_WITH_EMAIL_V2,
  LOGIN_WITH_EMAIL,
  RESET_PASSWORD,
  GET_CATEGORIES,
  GET_CURRENT_USER_PROFILE,
  GET_SABEQ,
  GET_USER_BY_ID,
  GET_USER_BY_USERNAME,
  GET_USER_BY_FACEBOOK_USER_ID,
  SET_NOTIFICATIONS_TOKEN,
  ADD_FRIEND_BY_USERNAME,
  GET_FRIENDS,
  GET_FRIENDS_LEADERBOARD,
  ACCEPT_FRIEND,
  REJECT_FRIEND,
  ADD_GROUP,
  GET_GROUP,
  GET_GROUP_LEADERBOARD,
  GET_GROUPS,
  ADD_GROUP_CHALLENGE,
  ADD_AZKAR_CHALLENGE,
  ADD_MEANING_CHALLENGE,
  FINISH_MEANING_CHALLENGE,
  ADD_PERSONAL_CHALLENGE,
  GET_ALL_CHALLENGES,
  GET_ALL_CHALLENGES_IN_GROUP,
  GET_AZKAR_CHALLENGE,
  DELETE_CHALLENGE,
  DELETE_PERSONAL_CHALLENGE,
  GET_ORIGINAL_CHALLENGE,
  UPDATE_AZKAR_CHALLENGE,
  UPDATE_PERSONAL_CHALLENGE,
  GET_PERSONAL_CHALLENGES,
}

class Endpoint {
  final EndpointRoute endpointRoute;
  List<String> pathVariables = List.empty();
  Map<String, String> requestParams = Map<String, String>();

  Endpoint(
      {@required this.endpointRoute, this.pathVariables, this.requestParams});
}

class ApiRoutesUtil {
  // ignore: missing_return
  static String apiRouteToString(Endpoint route) {
    switch (route.endpointRoute) {
      case EndpointRoute.BASE_URL:
        if (Platform.isAndroid) {
          // Use the following for testing locally.
          // return '10.0.2.2:8080';
          return 'www.tanafaso.com';
        }
        if (Platform.isIOS) {
          // Use the following for testing locally.
          // return '192.168.2.102:8080';
          return 'www.tanafaso.com';
        }
        assert(false);
        break;
      case EndpointRoute.LOGIN_WITH_FACEBOOK:
        return '/login/facebook';
      case EndpointRoute.CONNECT_FACEBOOK:
        return '/connect/facebook';
      case EndpointRoute.REGISTER_WITH_EMAIL_V2:
        return '/register/email/v2';
      case EndpointRoute.LOGIN_WITH_EMAIL:
        return '/login/email';
      case EndpointRoute.RESET_PASSWORD:
        return '/reset_password';
      case EndpointRoute.GET_CATEGORIES:
        return '/categories';
      case EndpointRoute.GET_CURRENT_USER_PROFILE:
        return 'users/me';
      case EndpointRoute.GET_SABEQ:
        return 'users/sabeq';
      case EndpointRoute.GET_USER_BY_ID:
        assert(route.pathVariables.length == 1);
        return 'users/${route.pathVariables[0]}';
      case EndpointRoute.GET_USER_BY_USERNAME:
        assert(route.requestParams.length == 1);
        assert(route.requestParams.keys.first == 'username');
        return '/users/search';
      case EndpointRoute.GET_USER_BY_FACEBOOK_USER_ID:
        assert(route.requestParams.length == 1);
        assert(route.requestParams.keys.first == 'facebook_user_id');
        return '/users/search';
      case EndpointRoute.SET_NOTIFICATIONS_TOKEN:
        return '/users/notifications/token';
      case EndpointRoute.ADD_FRIEND_BY_USERNAME:
        assert(route.pathVariables.length == 1);
        return '/friends/${route.pathVariables[0]}';
      case EndpointRoute.GET_FRIENDS:
        return '/friends';
      case EndpointRoute.GET_FRIENDS_LEADERBOARD:
        return '/friends/leaderboard';
      case EndpointRoute.ACCEPT_FRIEND:
        assert(route.pathVariables.length == 1);
        return '/friends/${route.pathVariables[0]}/accept';
      case EndpointRoute.REJECT_FRIEND:
        assert(route.pathVariables.length == 1);
        return '/friends/${route.pathVariables[0]}/reject';
      case EndpointRoute.ADD_GROUP:
        return '/groups';
      case EndpointRoute.GET_GROUP:
        assert(route.pathVariables.length == 1);
        return '/groups/${route.pathVariables[0]}';
      case EndpointRoute.GET_GROUP_LEADERBOARD:
        assert(route.pathVariables.length == 1);
        return '/groups/${route.pathVariables[0]}/leaderboard';
      case EndpointRoute.GET_GROUPS:
        return '/groups';
      case EndpointRoute.ADD_GROUP_CHALLENGE:
        return '/challenges';
      case EndpointRoute.ADD_AZKAR_CHALLENGE:
        return '/challenges/friends';
      case EndpointRoute.ADD_MEANING_CHALLENGE:
        return '/challenges/meaning';
      case EndpointRoute.FINISH_MEANING_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/finish/meaning/${route.pathVariables[0]}/';
      case EndpointRoute.ADD_PERSONAL_CHALLENGE:
        return '/challenges/personal';
      case EndpointRoute.GET_ALL_CHALLENGES:
        return '/challenges/v2';
      case EndpointRoute.GET_ALL_CHALLENGES_IN_GROUP:
        assert(route.pathVariables.length == 1);
        return '/challenges/groups/${route.pathVariables[0]}/';
      case EndpointRoute.GET_AZKAR_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/${route.pathVariables[0]}';
      case EndpointRoute.DELETE_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/${route.pathVariables[0]}';
      case EndpointRoute.DELETE_PERSONAL_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/personal/${route.pathVariables[0]}';
      case EndpointRoute.GET_ORIGINAL_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/original/${route.pathVariables[0]}';
      case EndpointRoute.UPDATE_AZKAR_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/${route.pathVariables[0]}';
      case EndpointRoute.UPDATE_PERSONAL_CHALLENGE:
        assert(route.pathVariables.length == 1);
        return '/challenges/personal/${route.pathVariables[0]}';
      case EndpointRoute.GET_PERSONAL_CHALLENGES:
        return '/challenges/personal';
      default:
        print('Route enum is not registered.');
    }
  }
}
