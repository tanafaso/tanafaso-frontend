import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/meaning_challenge.dart';

enum ChallengeType {
  AZKAR,
  MEANING,
}

class Challenge {
  Challenge({
    this.azkarChallenge,
    this.meaningChallenge,
  }) : challengeType = azkarChallenge != null
            ? ChallengeType.AZKAR
            : ChallengeType.MEANING;

  AzkarChallenge azkarChallenge;
  MeaningChallenge meaningChallenge;
  ChallengeType challengeType;

  factory Challenge.fromJson(Map<String, dynamic> json) {
    if (json["azkarChallenge"] == null) {
      return Challenge(
        meaningChallenge: MeaningChallenge.fromJson(json["meaningChallenge"]),
      );
    }
    return Challenge(
      azkarChallenge: AzkarChallenge.fromJson(json["azkarChallenge"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "azkarChallenge": azkarChallenge.toJson(),
        "meaningChallenge": meaningChallenge.toJson(),
      };

  String getId() {
    if (challengeType == ChallengeType.AZKAR) {
      return azkarChallenge.id;
    }
    return meaningChallenge.id;
  }

  String getGroupId() {
    if (challengeType == ChallengeType.AZKAR) {
      return azkarChallenge.groupId;
    }
    return meaningChallenge.groupId;
  }

  String getName() {
    if (challengeType == ChallengeType.AZKAR) {
      return azkarChallenge.name;
    }
    return meaningChallenge.getName();
  }

  bool done() {
    if (challengeType == ChallengeType.AZKAR) {
      return azkarChallenge.done();
    }
    return meaningChallenge.finished;
  }

  int getExpiryDate() {
    return challengeType == ChallengeType.AZKAR
        ? azkarChallenge.expiryDate
        : meaningChallenge.expiryDate;
  }

  bool deadlinePassed() {
    int secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return secondsSinceEpoch >= getExpiryDate();
  }

  int hoursLeft() {
    if (deadlinePassed()) {
      return 0;
    }
    int secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int secondsLeft = getExpiryDate() - secondsSinceEpoch;

    return secondsLeft ~/ 60 ~/ 60;
  }

  int minutesLeft() {
    if (deadlinePassed()) {
      return 0;
    }
    int secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int secondsLeft = getExpiryDate() - secondsSinceEpoch;
    return secondsLeft ~/ 60;
  }

  List<String> getUsersFinishedIds() {
    if (challengeType == ChallengeType.AZKAR) {
      return azkarChallenge.usersFinished;
    }
    return meaningChallenge.usersFinished;
  }

  String creatingUserId() {
    if (challengeType == ChallengeType.AZKAR) {
      return azkarChallenge.creatingUserId;
    }
    return meaningChallenge.creatingUserId;
  }
}
