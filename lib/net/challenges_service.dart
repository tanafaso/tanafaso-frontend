import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/requests/add_challenge_request_body.dart';
import 'package:azkar/net/payload/challenges/responses/add_challenge_response.dart';
import 'package:http/http.dart' as http;

class ChallengesService {
  Future<AddChallengeResponse> addGroupChallenge(
      AddChallengeRequestBody requestBody) async {
    http.Response response = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_GROUP_CHALLENGE),
        requestBody: requestBody);
    return AddChallengeResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddChallengeResponse> addPersonalChallenge(
      AddChallengeRequestBody requestBody) async {
    http.Response response = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_PERSONAL_CHALLENGE),
        requestBody: requestBody);
    return AddChallengeResponse.fromJson(jsonDecode(response.body));
  }
}
