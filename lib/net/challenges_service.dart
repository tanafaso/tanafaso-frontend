import 'dart:convert';

import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/requests/add_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/requests/add_friends_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/requests/update_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/responses/add_challenge_response.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenge_response.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/payload/challenges/responses/update_challenge_response.dart';
import 'package:http/http.dart' as http;

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

  Future<void> addPersonalChallenge(AddChallengeRequestBody requestBody) async {
    http.Response httpResponse = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_PERSONAL_CHALLENGE),
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

  Future<List<Challenge>> getPersonalChallenges() async {
    http.Response httpResponse = await ApiCaller.get(
        route: Endpoint(endpointRoute: EndpointRoute.GET_PERSONAL_CHALLENGES));
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

  Future<void> updatePersonalChallenge(Challenge challenge) async {
    UpdateChallengeRequestBody requestBody =
        UpdateChallengeRequestBody(challenge: challenge);
    http.Response httpResponse = await ApiCaller.put(
        route: Endpoint(
            endpointRoute: EndpointRoute.UPDATE_PERSONAL_CHALLENGE,
            pathVariables: [challenge.id]),
        requestBody: requestBody);
    var response = UpdateChallengeResponse.fromJson(
        jsonDecode(utf8.decode(httpResponse.body.codeUnits)));
    if (response.hasError()) {
      throw new ApiException(response.getErrorMessage());
    }
  }
}
