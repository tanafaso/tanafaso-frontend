import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<GetUserResponse> getCurrentUser() async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_CURRENT_USER_PROFILE));
    return GetUserResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<GetUserResponse> getUserById(String id) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_ID, pathVariables: [id]));
    return GetUserResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<GetUserResponse> getUserByUsername(String username) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_USERNAME,
            requestParams: {'username': username}));
    return GetUserResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<GetUserResponse> getUserByFacebookUserId(String facebookUserId) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_USER_BY_FACEBOOK_USER_ID,
            requestParams: {'facebook_user_id': facebookUserId}));
    return GetUserResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<AddFriendResponse> addFriend(String username) async {
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
    return AddFriendResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<GetFriendsResponse> getFriends() async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_FRIENDS));
    return GetFriendsResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<ResolveFriendRequestResponse> acceptFriend(String friendId) async {
    http.Response response = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.ACCEPT_FRIEND,
            pathVariables: [friendId]));
    return ResolveFriendRequestResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<ResolveFriendRequestResponse> rejectFriend(String friendId) async {
    http.Response response = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.REJECT_FRIEND,
            pathVariables: [friendId]));
    return ResolveFriendRequestResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }
}
