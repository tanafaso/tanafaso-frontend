import 'package:azkar/views/core_views/challenges/create_challenge/select_zekr_screen.dart';
import 'package:flutter/material.dart';

class CreateChallengeWidget extends StatefulWidget {
  @override
  _CreateChallengeWidgetState createState() => _CreateChallengeWidgetState();
}

enum ChallengeTarget { self, friend, group }

class _CreateChallengeWidgetState extends State<CreateChallengeWidget> {
  ChallengeTarget _challengeTarget = ChallengeTarget.self;
  String _friendId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Challenge'),
        ),
        body: Center(
            child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(children: [
              Text('I want to challenge ...'),
              Column(
                children: getChallengeTargets(),
              ),
              Row(
                children: [
                  Text('Friend name: '),
                  Container(
                    width: 200,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _friendId,
                      hint: Text('Choose a friend'),
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _friendId = newValue;
                        });
                      },
                      items: <String>['one', 'Two', 'Free', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                              'أَصْـبَحْنا وَأَصْـبَحَ المُـلْكُ لله وَالحَمدُ لله ، لا إلهَ إلاّ اللّهُ وَحدَهُ لا شَريكَ لهُ، لهُ المُـلكُ ولهُ الحَمْـد، وهُوَ على كلّ شَيءٍ قدير ، رَبِّ أسْـأَلُـكَ خَـيرَ ما في هـذا اليوم وَخَـيرَ ما بَعْـدَه ، وَأَعـوذُ بِكَ مِنْ شَـرِّ ما في هـذا اليوم وَشَرِّ ما بَعْـدَه، رَبِّ أَعـوذُبِكَ مِنَ الْكَسَـلِ وَسـوءِ الْكِـبَر ، رَبِّ أَعـوذُ بِكَ مِنْ عَـذابٍ في النّـارِ وَعَـذابٍ في القَـبْر'),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectZekrWidget()));
                },
              )
            ]),
          ),
        )));
  }

  List<Widget> getChallengeTargets() {
    return <Widget>[
      ListTile(
        title: const Text('myself'),
        leading: Radio(
          value: ChallengeTarget.self,
          groupValue: _challengeTarget,
          onChanged: (ChallengeTarget value) {
            setState(() {
              _challengeTarget = value;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('a friend'),
        leading: Radio(
          value: ChallengeTarget.friend,
          groupValue: _challengeTarget,
          onChanged: (ChallengeTarget value) {
            setState(() {
              _challengeTarget = value;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('a group'),
        leading: Radio(
          value: ChallengeTarget.group,
          groupValue: _challengeTarget,
          onChanged: (ChallengeTarget value) {
            setState(() {
              _challengeTarget = value;
            });
          },
        ),
      ),
    ];
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}
