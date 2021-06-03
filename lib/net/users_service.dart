import 'dart:convert';

import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/users/requests/set_notifications_token_request_body.dart';
import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/payload/users/responses/get_friends_leaderboard_response.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:azkar/net/payload/users/responses/set_notifications_token_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersService {
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
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    String key = CacheManager.CACHE_KEY_CURRENT_USER_ID.toString();
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    }
    User user = await getCurrentUser();
    prefs.setString(key, user.id);
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

  Future<String> getUserFullNameById(String id) async {
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    String key = CacheManager.CACHE_KEY_USER_FULL_NAME_PREFIX.toString() + id;
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    }
    User user = await getUserById(id);
    String fullName = user.firstName + " " + user.lastName;
    prefs.setString(key, fullName);
    return fullName;
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

  Future<List<FriendshipScores>> getFriendsLeaderboard() async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_FRIENDS_LEADERBOARD));
    var response = GetFriendsLeaderboardResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.friendshipScores;
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
