import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:http/http.dart' as http;

class UsersService {
  static Future<GetUserResponse> getCurrentUser() async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_CURRENT_USER_PROFILE));
    return GetUserResponse.fromJson(jsonDecode(response.body));
  }

  static Future<GetUserResponse> getUserByUsername(String username) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_USERNAME,
            requestParams: {'username': username}));
    return GetUserResponse.fromJson(jsonDecode(response.body));
  }

  static Future<AddFriendResponse> addFriend(String username) async {
    GetUserResponse getUserResponse = await getUserByUsername(username);

    if (getUserResponse.hasError()) {
      AddFriendResponse addFriendResponse = AddFriendResponse();
      addFriendResponse.setErrorMessage(getUserResponse.error.errorMessage);
      return addFriendResponse;
    }

    String userId = getUserResponse.user.id;
    assert(userId != null);
    http.Response response = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.ADD_FRIEND_BY_USERNAME,
            pathVariables: [userId]));
    return AddFriendResponse.fromJson(jsonDecode(response.body));
  }

  static Future<GetFriendsResponse> getFriends() async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_FRIENDS));
    return GetFriendsResponse.fromJson(jsonDecode(response.body));
  }

  static Future<ResolveFriendRequestResponse> acceptFriend(
      String friendId) async {
    http.Response response = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.ACCEPT_FRIEND,
            pathVariables: [friendId]));
    return ResolveFriendRequestResponse.fromJson(jsonDecode(response.body));
  }

  static Future<ResolveFriendRequestResponse> rejectFriend(
      String friendId) async {
    http.Response response = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.REJECT_FRIEND,
            pathVariables: [friendId]));
    return ResolveFriendRequestResponse.fromJson(jsonDecode(response.body));
  }
}
