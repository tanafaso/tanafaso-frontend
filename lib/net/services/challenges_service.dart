import 'dart:convert';

import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_azkar_challenge_in_group_request.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_azkar_challenge_request_body.dart';
import 'package:azkar/net/api_interface/challenges/requests/add_meaning_challenge_request_body.dart';
import 'package:azkar/net/api_interface/challenges/requests/update_azkar_challenge_request_body.dart';
import 'package:azkar/net/api_interface/challenges/responses/FinishMeaningChallengeResponse.dart';
import 'package:azkar/net/api_interface/challenges/responses/add_azkar_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/add_meaning_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/delete_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/get_azkar_challenge_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/api_interface/challenges/responses/update_azkar_challenge_response.dart';
import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChallengesService {
  Future<void> addGroupChallenge(
      AddAzkarChallengeInGroupRequest requestBody) async {
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_GROUP_CHALLENGE),
        requestBody: requestBody);

    var response = AddAzkarChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }

  Future<void> addAzkarChallenge(
      AddAzkarChallengeRequestBody requestBody) async {
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_AZKAR_CHALLENGE),
        requestBody: requestBody);

    var response = AddAzkarChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }

  Future<void> addMeaningChallenge(
      AddMeaningChallengeRequestBody requestBody) async {
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_MEANING_CHALLENGE),
        requestBody: requestBody);

    var response = AddMeaningChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }

  Future<void> finishMeaningChallenge(String id) async {
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.FINISH_MEANING_CHALLENGE,
            pathVariables: [id]));

    var response = FinishMeaningChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }

  Future<List<Challenge>> getAllChallenges() async {
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    String key = CacheManager.CACHE_KEY_CHALLENGES.toString();

    if (prefs.containsKey(key)) {
      return GetChallengesResponse.fromJson(jsonDecode(prefs.getString(key)))
          .challenges;
    }

    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_ALL_CHALLENGES));
    String responseBody = utf8.decode(httpResponse.body.codeUnits);
    var response = GetChallengesResponse.fromJson(jsonDecode(responseBody));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    prefs.setString(key, responseBody);
    return response.challenges;
  }

  Future<AzkarChallenge> getAzkarChallenge(String challengeId) async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_AZKAR_CHALLENGE,
            pathVariables: [challengeId]));
    var response = GetAzkarChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    return response.challenge;
  }

  Future<void> deleteChallenge(String challengeId) async {
    http.Response httpResponse = await ApiCaller.delete(
        route: Endpoint(
            endpointRoute: EndpointRoute.DELETE_CHALLENGE,
            pathVariables: [challengeId]));
    var response = DeleteChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }

  Future<AzkarChallenge> getOriginalChallenge(String challengeId) async {
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    String key = CacheManager.CACHE_KEY_ORIGINAL_CHALLENGE_PREFIX.toString() +
        challengeId;
    if (prefs.containsKey(key)) {
      return AzkarChallenge.fromJson(json.decode(prefs.getString(key)));
    }
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(
            endpointRoute: EndpointRoute.GET_ORIGINAL_CHALLENGE,
            pathVariables: [challengeId]));
    var response = GetAzkarChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
    prefs.setString(key, json.encode(response.challenge.toJson()));
    return response.challenge;
  }

  Future<void> updateAzkarChallenge(AzkarChallenge challenge) async {
    UpdateAzkarChallengeRequestBody requestBody =
        UpdateAzkarChallengeRequestBody(challenge: challenge);
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.UPDATE_AZKAR_CHALLENGE,
            pathVariables: [challenge.id]),
        requestBody: requestBody);
    var response = UpdateAzkarChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }
}
