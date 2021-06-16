import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/net/api_interface/response_base.dart';

class GetFriendsLeaderboardResponse extends ResponseBase {
  List<FriendshipScores> friendshipScores;

  static GetFriendsLeaderboardResponse fromJson(Map<String, dynamic> json) {
    GetFriendsLeaderboardResponse response =
        new GetFriendsLeaderboardResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    response.friendshipScores = [];
    for (var friendshipScore in json['data']) {
      response.friendshipScores.add(FriendshipScores.fromJson(friendshipScore));
    }
    return response;
  }
}
