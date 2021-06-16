import 'package:azkar/models/group.dart';
import 'package:azkar/net/api_interface/response_base.dart';

class GetGroupsResponse extends ResponseBase {
  List<Group> groups;

  static GetGroupsResponse fromJson(Map<String, dynamic> json) {
    GetGroupsResponse response = new GetGroupsResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    response.groups = [];
    for (var jsonGroup in json['data']) {
      response.groups.add(Group.fromJson(jsonGroup));
    }
    return response;
  }
}
