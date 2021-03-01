class UserGroup {
  UserGroup({
    this.groupId,
    this.groupName,
    this.invitingUserId,
    this.monthScore,
    this.totalScore,
    this.pending,
  });

  String groupId;
  String groupName;
  dynamic invitingUserId;
  int monthScore;
  int totalScore;
  bool pending;

  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
        groupId: json["groupId"],
        groupName: json["groupName"],
        invitingUserId: json["invitingUserId"],
        monthScore: json["monthScore"],
        totalScore: json["totalScore"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "invitingUserId": invitingUserId,
        "monthScore": monthScore,
        "totalScore": totalScore,
        "pending": pending,
      };
}
