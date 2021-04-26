import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/service_provider.dart';
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
      addAutomaticKeepAlives: true,
      // Cache half screen after and half screen before the current screen.
      cacheExtent: MediaQuery.of(context).size.height * 0.5,
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return GroupChallengeListItemWidget(
          challenge: challenges[index],
          challengeChangedCallback: (_) {
            setState(() {});
          },
        );
      },
    );
  }
}
