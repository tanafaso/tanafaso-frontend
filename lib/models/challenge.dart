import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/meaning_challenge.dart';
import 'package:azkar/models/memorization_challenge.dart';
import 'package:azkar/models/reading_quran_challenge.dart';

enum ChallengeType {
  AZKAR,
  MEANING,
  READING_QURAN,
  MEMORIZATION,
  OTHER,
}

class Challenge {
  Challenge({
    this.azkarChallenge,
    this.meaningChallenge,
    this.readingQuranChallenge,
    this.memorizationChallenge,
  }) : challengeType = azkarChallenge != null
            ? ChallengeType.AZKAR
            : meaningChallenge != null
                ? ChallengeType.MEANING
                : readingQuranChallenge != null
                    ? ChallengeType.READING_QURAN
                    : ChallengeType.MEMORIZATION;

  AzkarChallenge azkarChallenge;
  MeaningChallenge meaningChallenge;
  ReadingQuranChallenge readingQuranChallenge;
  MemorizationChallenge memorizationChallenge;
  ChallengeType challengeType;

  factory Challenge.fromJson(Map<String, dynamic> json) {
    if (json["azkarChallenge"] != null) {
      return Challenge(
        azkarChallenge: AzkarChallenge.fromJson(json["azkarChallenge"]),
      );
    } else if (json["meaningChallenge"] != null) {
      return Challenge(
        meaningChallenge: MeaningChallenge.fromJson(json["meaningChallenge"]),
      );
    } else if (json["readingQuranChallenge"] != null) {
      return Challenge(
        readingQuranChallenge:
            ReadingQuranChallenge.fromJson(json["readingQuranChallenge"]),
      );
    } else if (json["memorizationChallenge"] != null) {
      return Challenge(
        memorizationChallenge:
            MemorizationChallenge.fromJson(json["memorizationChallenge"]),
      );
    }

    return Challenge();
  }

  Map<String, dynamic> toJson() => {
        "azkarChallenge":
            azkarChallenge == null ? null : azkarChallenge.toJson(),
        "meaningChallenge":
            meaningChallenge == null ? null : meaningChallenge.toJson(),
        "readingQuranChallenge": readingQuranChallenge == null
            ? null
            : readingQuranChallenge.toJson(),
        "memorizationChallenge": memorizationChallenge == null
            ? null
            : memorizationChallenge.toJson(),
      };

  String getId() {
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.id;
      case ChallengeType.MEANING:
        return meaningChallenge.id;
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.id;
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.id;
      case ChallengeType.OTHER:
        return null;
    }
    return null;
  }

  String getGroupId() {
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.groupId;
      case ChallengeType.MEANING:
        return meaningChallenge.groupId;
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.groupId;
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.groupId;
      case ChallengeType.OTHER:
        return null;
    }
    return null;
  }

  String getName() {
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.name;
      case ChallengeType.MEANING:
        return meaningChallenge.getName();
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.getName();
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.getName();
      case ChallengeType.OTHER:
        return null;
    }
    return null;
  }

  bool done() {
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.done();
      case ChallengeType.MEANING:
        return meaningChallenge.finished;
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.finished;
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.done();
      case ChallengeType.OTHER:
        return false;
    }
    return false;
  }

  int getExpiryDate() {
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.expiryDate;
      case ChallengeType.MEANING:
        return meaningChallenge.expiryDate;
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.expiryDate;
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.expiryDate;
      case ChallengeType.OTHER:
        return 0;
    }
    return 0;
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
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.usersFinished;
      case ChallengeType.MEANING:
        return meaningChallenge.usersFinished;
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.usersFinished;
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.usersFinished;
      case ChallengeType.OTHER:
        return [];
    }
    return [];
  }

  String creatingUserId() {
    switch (challengeType) {
      case ChallengeType.AZKAR:
        return azkarChallenge.creatingUserId;
      case ChallengeType.MEANING:
        return meaningChallenge.creatingUserId;
      case ChallengeType.READING_QURAN:
        return readingQuranChallenge.creatingUserId;
      case ChallengeType.MEMORIZATION:
        return memorizationChallenge.creatingUserId;
      case ChallengeType.OTHER:
        return null;
    }
    return null;
  }
}
