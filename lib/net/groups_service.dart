import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/groups/requests/add_group_request_body.dart';
import 'package:azkar/net/payload/groups/responses/add_group_response.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  Future<AddGroupResponse> addGroup(AddGroupRequestBody requestBody) async {
    http.Response response = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_GROUP),
        requestBody: requestBody);
    print(response.body);
    return AddGroupResponse.fromJson(jsonDecode(response.body));
  }
}
