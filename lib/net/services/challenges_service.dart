import 'dart:convert';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_challenge_request_body.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_friends_challenge_request_body.dart';
import 'package:azkar/net/api_interface/challenges/requests/update_challenge_request_body.dart';
import 'package:azkar/net/api_interface/challenges/responses/add_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/delete_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/get_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/update_challenge_response.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChallengesService {
  Future<void> addGroupChallenge(AddChallengeRequestBody requestBody) async {
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_GROUP_CHALLENGE),
        requestBody: requestBody);

    var response = AddChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }

  Future<void> addFriendsChallenge(
      AddFriendsChallengeRequestBody requestBody) async {
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_FRIENDS_CHALLENGE),
        requestBody: requestBody);

    var response = AddChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }

  Future<List<Challenge>> getAllChallenges() async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_ALL_CHALLENGES));
    var response = GetChallengesResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.challenges;
  }

  Future<Challenge> getChallenge(String challengeId) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_CHALLENGE,
            pathVariables: [challengeId]));
    var response = GetChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.challenge;
  }

  Future<void> deleteGroupChallenge(String challengeId) async {
    http.Response httpResponse = await ApiCaller.delete(
        route: Endpoint(
            endpointRoute: EndpointRoute.DELETE_CHALLENGE,
            pathVariables: [challengeId]));
    var response = DeleteChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }

  Future<Challenge> getOriginalChallenge(String challengeId) async {
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    String key = CacheManager.CACHE_KEY_ORIGINAL_CHALLENGE_PREFIX.toString() +
        challengeId;
    if (prefs.containsKey(key)) {
      return Challenge.fromJson(json.decode(prefs.getString(key)));
    }
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_ORIGINAL_CHALLENGE,
            pathVariables: [challengeId]));
    var response = GetChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    prefs.setString(key, json.encode(response.challenge.toJson()));
    return response.challenge;
  }

  Future<void> updateChallenge(Challenge challenge) async {
    UpdateChallengeRequestBody requestBody =
        UpdateChallengeRequestBody(challenge: challenge);
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.UPDATE_CHALLENGE,
            pathVariables: [challenge.id]),
        requestBody: requestBody);
    var response = UpdateChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }
}
