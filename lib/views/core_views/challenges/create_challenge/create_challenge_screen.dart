import 'package:azkar/models/friend.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_azkar_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_meaning_challenge_screen.dart';
import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatelessWidget {
  final List<Friend> initiallySelectedFriends;

  CreateChallengeScreen({this.initiallySelectedFriends = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اختر نوع التحدي"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => CreateAzkarChallengeScreen(
                                initiallySelectedFriends:
                                    initiallySelectedFriends,
                              )));
                    },
                    child: Text('قراءة الأذكار'),
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => CreateMeaningChallengeScreen(
                                initiallySelectedFriends:
                                    initiallySelectedFriends,
                              )));
                    },
                    child: Text('تفسير القرآن'),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: EdgeInsets.all(15.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
