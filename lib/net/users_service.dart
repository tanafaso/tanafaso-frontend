import 'dart:convert';

import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/users/requests/set_notifications_token_request_body.dart';
import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:azkar/net/payload/users/responses/set_notifications_token_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const String CACHE_KEY_CURRENT_USER_ID = "0";

  Future<User> getCurrentUser() async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_CURRENT_USER_PROFILE));
    var response = GetUserResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.user;
  }

  // Either returns the current user's ID or throws an ApiException.
  Future<String> getCurrentUserId() async {
    SharedPreferences prefs = await _prefs;
    if (prefs.containsKey(CACHE_KEY_CURRENT_USER_ID)) {
      return prefs.getString(CACHE_KEY_CURRENT_USER_ID);
    }
    User user = await getCurrentUser();
    prefs.setString(CACHE_KEY_CURRENT_USER_ID, user.id);
    return user.id;
  }

  Future<User> getUserById(String id) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_ID, pathVariables: [id]));
    var response = GetUserResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.user;
  }

  Future<User> getUserByUsername(String username) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_USERNAME,
            requestParams: {'username': username}));
    var response = GetUserResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.user;
  }

  Future<User> getUserByFacebookUserId(String facebookUserId) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_FACEBOOK_USER_ID,
            requestParams: {'facebook_user_id': facebookUserId}));
    var response = GetUserResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.user;
  }

  Future<void> addFriend(String username) async {
    User user = await getUserByUsername(username);

    String userId = user.id;
    assert(userId != null);
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.ADD_FRIEND_BY_USERNAME,
            pathVariables: [userId]));
    var response = AddFriendResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }

  Future<Friendship> getFriends() async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_FRIENDS));
    var response = GetFriendsResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.friendship;
  }

  Future<void> acceptFriend(String friendId) async {
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.ACCEPT_FRIEND,
            pathVariables: [friendId]));
    var response = ResolveFriendRequestResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }

  Future<void> rejectFriend(String friendId) async {
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.REJECT_FRIEND,
            pathVariables: [friendId]));
    var response = ResolveFriendRequestResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }

  Future<void> setNotificationsToken(
      SetNotificationsTokenRequestBody requestBody) async {
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(endpointRoute: EndpointRoute.SET_NOTIFICATIONS_TOKEN),
        requestBody: requestBody);
    var response = SetNotificationsTokenResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }
}
