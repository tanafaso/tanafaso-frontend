import 'dart:convert';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/user_score.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/payload/groups/responses/get_group_leaderboard_response.dart';
import 'package:azkar/net/payload/groups/responses/get_group_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupsService {
  Future<Group> getGroup(String groupId) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_GROUP, pathVariables: [groupId]));
    var response = GetGroupResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.group;
  }

  Future<CachedGroupInfo> getCachedGroupInfo(String groupId) async {
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    String key = CacheManager.CACHE_KEY_GROUP_ID_PREFIX.toString() + groupId;
    if (prefs.containsKey(key)) {
      return CachedGroupInfo.fromJson(json.decode(prefs.getString(key)));
    }

    Group group = await getGroup(groupId);
    CachedGroupInfo cachedGroupInfo = CachedGroupInfo.fromGroup(group);
    prefs.setString(key, json.encode(cachedGroupInfo.toJson()));
    return cachedGroupInfo;
  }

  Future<List<UserScore>> getGroupLeaderboard(String groupId) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_GROUP_LEADERBOARD,
            pathVariables: [groupId]));
    var response = GetGroupLeaderboardResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.userScores;
  }

  Future<List<Challenge>> getAllChallengesInGroup(String groupId) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_ALL_CHALLENGES_IN_GROUP,
            pathVariables: [groupId]));
    var response = GetChallengesResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.challenges;
  }
}
