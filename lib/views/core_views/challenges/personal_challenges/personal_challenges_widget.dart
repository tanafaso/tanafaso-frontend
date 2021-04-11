import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/challenges/personal_challenges/personal_challenges_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class PersonalChallengesWidget extends StatefulWidget {
  @override
  _PersonalChallengesWidgetState createState() =>
      _PersonalChallengesWidgetState();
}

class _PersonalChallengesWidgetState extends State<PersonalChallengesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GetChallengesResponse>(
        future: ServiceProvider.challengesService.getPersonalChallenges(),
        builder: (BuildContext context,
            AsyncSnapshot<GetChallengesResponse> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getPersonalChallengesListWidget(snapshot.data.challenges);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                    '${AppLocalizations.of(context).error}: ${snapshot.error}'),
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

  Widget getPersonalChallengesListWidget(List<Challenge> challenges) {
    if (challenges == null || challenges.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).noPersonalChallengesFound,
          key: Keys.personalChallengesWidgetNoChallengesFoundKey,
        ),
      );
    }

    return ListView.builder(
      key: Keys.personalChallengesWidgetListKey,
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return PersonalChallengesListItemWidget(
          challenge: challenges[index],
        );
      },
    );
  }
}
