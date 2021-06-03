import 'package:azkar/models/friend.dart';

class FriendshipScores {
  int currentUserScore;
  int friendScore;
  Friend friend;

  FriendshipScores({
    this.currentUserScore,
    this.friendScore,
    this.friend,
  });

  factory FriendshipScores.fromJson(Map<String, dynamic> json) =>
      FriendshipScores(
        currentUserScore: json["currentUserScore"],
        friendScore: json["friendScore"],
        friend: Friend.fromJson(json["friend"]),
      );
}
