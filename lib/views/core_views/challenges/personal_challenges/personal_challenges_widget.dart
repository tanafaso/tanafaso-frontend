import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
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
      child: FutureBuilder<List<Challenge>>(
        future: ServiceProvider.challengesService.getPersonalChallenges(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Challenge>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getPersonalChallengesListWidget(snapshot.data);
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SnapshotUtils.getErrorWidget(context, snapshot),
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
      // Cache half screen after and half screen before the current screen.
      cacheExtent: MediaQuery.of(context).size.height * 0.5,
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return PersonalChallengesListItemWidget(
          challenge: challenges[index],
          challengeChangedCallback: (_) {
            setState(() {});
          },
        );
      },
    );
  }
}
