class Group {
  String id;
  String name;
  String adminId;
  List<String> usersIds;
  List<String> challengesIds;
  bool binary;

  Group({
    this.id,
    this.name,
    this.adminId,
    this.usersIds,
    this.challengesIds,
    this.binary,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "adminId": adminId,
        "usersIds": List<dynamic>.from(usersIds.map((x) => x)),
        "challengesIds": List<dynamic>.from(challengesIds.map((x) => x)),
        "binary": binary,
      };
}
