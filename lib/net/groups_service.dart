import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/groups/requests/add_group_request_body.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  Future<void> addGroup(AddGroupRequestBody requestBody) async {
    http.Response response = await ApiCaller.post(
        route: Endpoint(endpointRoute: EndpointRoute.ADD_GROUP),
        requestBody: requestBody);
  }
}
