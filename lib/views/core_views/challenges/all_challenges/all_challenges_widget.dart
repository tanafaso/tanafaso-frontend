import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class AllChallengesWidget extends StatefulWidget {
  @override
  _AllChallengesWidgetState createState() => _AllChallengesWidgetState();
}

class _AllChallengesWidgetState extends State<AllChallengesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          ServiceProvider.challengesService.getAllChallenges(),
          ServiceProvider.groupsService.getGroups()
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return getChallengesListWidget(snapshot.data[0], snapshot.data[1]);
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

  Widget getChallengesListWidget(
      List<Challenge> challenges, List<Group> groups) {
    if (challenges == null || challenges.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).noChallengesFound,
          key: Keys.allChallengesWidgetNoChallengesFoundKey,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        setState(() {});
        return Future.value();
      },
      color: Colors.black,
      child: ListView.separated(
        key: Keys.allChallengesWidgetListKey,
        addAutomaticKeepAlives: true,
        // Cache half screen after and half screen before the current screen.
        cacheExtent: MediaQuery.of(context).size.height * 0.5,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 4),
        ),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return GroupChallengeListItemWidget(
            key: Key(challenges[index].id),
            challenge: challenges[index],
            group: groups
                .firstWhere((group) => group.id == challenges[index].groupId),
            challengeChangedCallback: (_) {
              setState(() {});
            },
            firstChallengeInList: index == 0,
          );
        },
      ),
    );
  }
}
