import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
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
}
