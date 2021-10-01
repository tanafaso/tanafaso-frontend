import 'package:auto_size_text/auto_size_text.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_azkar_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_meaning_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_quran_reading_challenge_screen.dart';
import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatelessWidget {
  final List<Friend> initiallySelectedFriends;

  CreateChallengeScreen({this.initiallySelectedFriends = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "اختر نوع التحدي",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          isAlwaysShown: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: FittedBox(
                      child: Text(
                        '{وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateAzkarChallengeScreen(
                                      initiallySelectedFriends:
                                          initiallySelectedFriends,
                                    )));
                          },
                          child: Column(
                            children: [
                              AutoSizeText(
                                'قراءة أذكار',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              AutoSizeText(
                                'اختر مجموعة من الأذكار وتكرار كل ذِكر وتحدى نفسك و بعض أصدقائك أن يقرؤوها.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 25),
                              ),
                            ],
                          ),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Row(
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateMeaningChallengeScreen(
                                      initiallySelectedFriends:
                                          initiallySelectedFriends,
                                    )));
                          },
                          child: Column(
                            children: [
                              AutoSizeText(
                                'معاني كلمات القرآن',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              AutoSizeText(
                                'تحدى نفسك و بعض أصدقائك أن يختاروا المعاني الصحيحة لعدد معين من كلمات القرآن الكريم.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 25),
                              ),
                            ],
                          ),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Row(
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateQuranReadingChallengeScreen(
                                      initiallySelectedFriends:
                                          initiallySelectedFriends,
                                    )));
                          },
                          child: Column(
                            children: [
                              AutoSizeText(
                                'قراءة قرآن',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              AutoSizeText(
                                'تحدى نفسك وبعض أصدقائك أن يقرؤوا بعض آيات القرآن الكريم.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 25),
                              ),
                            ],
                          ),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
