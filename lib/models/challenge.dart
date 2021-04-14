import 'sub_challenge.dart';

class Challenge {
  Challenge({
    this.id,
    this.groupId,
    this.creatingUserId,
    this.motivation,
    this.name,
    this.expiryDate,
    this.usersFinished = const [],
    this.subChallenges,
  });

  String id;
  String groupId;
  String creatingUserId;
  String motivation;
  String name;

  // In seconds since epoch
  int expiryDate;
  List<String> usersFinished;
  List<SubChallenge> subChallenges;

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["id"],
        groupId: json["groupId"],
        creatingUserId: json["creatingUserId"],
        motivation: json["motivation"],
        name: json["name"],
        expiryDate: json["expiryDate"],
        usersFinished: List<String>.from(json["usersFinished"].map((x) => x)),
        subChallenges: List<SubChallenge>.from(
            json["subChallenges"].map((x) => SubChallenge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupId": groupId,
        "creatingUserId": creatingUserId,
        "motivation": motivation,
        "name": name,
        "expiryDate": expiryDate,
        "usersFinished": List<String>.from(usersFinished.map((x) => x)),
        "subChallenges":
            List<dynamic>.from(subChallenges.map((x) => x.toJson())),
      };

  bool done() {
    for (SubChallenge subChallenge in subChallenges) {
      if (!subChallenge.done()) {
        return false;
      }
    }
    return true;
  }

  bool deadlinePassed() {
    int secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return secondsSinceEpoch >= expiryDate;
  }

  int hoursLeft() {
    if (deadlinePassed()) {
      return 0;
    }
    int secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int secondsLeft = expiryDate - secondsSinceEpoch;
    return secondsLeft ~/ 60 ~/ 60;
  }

  int minutesLeft() {
    if (deadlinePassed()) {
      return 0;
    }
    int secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int secondsLeft = expiryDate - secondsSinceEpoch;
    return secondsLeft ~/ 60;
  }
}
