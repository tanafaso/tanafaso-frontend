import 'package:azkar/models/Group.dart';
import 'package:azkar/net/payload/response_base.dart';

class AddGroupResponse extends ResponseBase {
  Group group;

  AddGroupResponse({
    this.group
  });

  factory AddGroupResponse.fromJson(Map<String, dynamic> json) {
    AddGroupResponse response = new AddGroupResponse();
    response.setError(json);

    var data = json['data'];
    response.group = new Group(
      id: data["id"],
      name: data["name"],
      adminId: data["adminId"],
      usersIds: List<String>.from(data["usersIds"].map((x) => x)),
      challengesIds: List<String>.from(data["challengesIds"].map((x) => x)),
      binary: data["binary"],
    );

    return response;
  }
}
