class SubChallenge {
  String zekrId;
  String zekr;
  int repetitions;

  SubChallenge({this.zekrId, this.zekr, this.repetitions});

  factory SubChallenge.fromJson(Map<String, dynamic> json) => SubChallenge(
        zekrId: json["zekrId"],
        zekr: json["zekr"],
        repetitions: json["repetitions"],
      );

  Map<String, dynamic> toJson() => {
        "zekrId": zekrId,
        "zekr": zekr,
        "repetitions": repetitions,
      };
}
