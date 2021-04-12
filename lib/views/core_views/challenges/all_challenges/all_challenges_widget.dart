import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/challenges/challenge_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class AllChallengesWidget extends StatefulWidget {
  @override
  _AllChallengesWidgetState createState() => _AllChallengesWidgetState();
}

class _AllChallengesWidgetState extends State<AllChallengesWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GetChallengesResponse>(
        future: ServiceProvider.challengesService.getAllChallenges(),
        builder: (BuildContext context,
            AsyncSnapshot<GetChallengesResponse> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getChallengesListWidget(snapshot.data.challenges);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                    '${AppLocalizations.of(context).loadingTheChallenges}...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }

  Widget getChallengesListWidget(List<Challenge> challenges) {
    if (challenges == null || challenges.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).noChallengesFound,
          key: Keys.allChallengesWidgetNoChallengesFoundKey,
        ),
      );
    }

    return ListView.builder(
      key: Keys.allChallengesWidgetListKey,
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return ChallengeListItemWidget(
          challenge: challenges[index],
          challengeChangedCallback: (_){},
        );
      },
    );
  }
}
