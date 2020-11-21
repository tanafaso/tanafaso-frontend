import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/payload/response_base.dart';

class GetFriendsResponse extends ResponseBase {
  Friendship friendship;

  static GetFriendsResponse fromJson(Map<String, dynamic> json) {
    GetFriendsResponse response = new GetFriendsResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }

    var data = json['data'];
    var friends = getFriends(json);
    response.friendship = Friendship(
      id: data['id'],
      userId: data['userId'],
      friends: friends,
    );

    return response;
  }

  static List<Friend> getFriends(Map<String, dynamic> json) {
    List<Friend> friends = [];
    for (var friend in json['data']['friends']) {
      friends.add(Friend(
          userId: friend['userId'],
          username: friend['username'],
          name: friend['name'],
          pending: friend['pending']));
    }
    return friends;
  }
}
