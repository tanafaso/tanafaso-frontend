import 'package:azkar/models/user_group.dart';
import 'package:azkar/net/payload/response_base.dart';

class GetGroupsResponse extends ResponseBase {
  List<UserGroup> userGroups = [];

  GetGroupsResponse();

  factory GetGroupsResponse.fromJson(Map<String, dynamic> json) {
    GetGroupsResponse response = new GetGroupsResponse();
    response.setError(json);

    if (response.hasError()) {
      return response;
    }

    var data = json['data'];
    for (var userGroupJson in data) {
      response.userGroups.add(UserGroup.fromJson(userGroupJson));
    }

    return response;
  }
}
