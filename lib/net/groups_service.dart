import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenge_response.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/payload/groups/responses/get_group_leaderboard_response.dart';
import 'package:azkar/net/payload/groups/responses/get_group_response.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  Future<GetGroupResponse> getGroup(String groupId) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_GROUP, pathVariables: [groupId]));
    return GetGroupResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<GetGroupLeaderboardResponse> getGroupLeaderboard(
      String groupId) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_GROUP_LEADERBOARD,
            pathVariables: [groupId]));
    return GetGroupLeaderboardResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }

  Future<GetChallengesResponse> getAllChallengesInGroup(String groupId) async {
    http.Response response = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_ALL_CHALLENGES_IN_GROUP,
            pathVariables: [groupId]));
    return GetChallengesResponse.fromJson(
        jsonDecode(utf8.decode(response.body.codeUnits)));
  }
}
