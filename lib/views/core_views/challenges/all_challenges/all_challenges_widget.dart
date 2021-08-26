import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/challenge_list_item_loading_widget.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/challenge_list_item_widget.dart';
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
          ServiceProvider.groupsService.getGroups(),
          ServiceProvider.usersService.getFriendsLeaderboard(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return getChallengesListWidget(
                snapshot.data[0], snapshot.data[1], snapshot.data[2]);
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
            children =
                List.generate(3, (_) => ChallengeListItemLoadingWidget());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }

  Widget getChallengesListWidget(List<Challenge> challenges, List<Group> groups,
      List<FriendshipScores> friendshipScores) {
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
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
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
            return ChallengeListItemWidget(
              key: Key(challenges[index].getId()),
              challenge: challenges[index],
              group: groups.firstWhere(
                  (group) => group.id == challenges[index].getGroupId()),
              challengeChangedCallback: (_) {
                setState(() {});
              },
              firstChallengeInList: index == 0,
              friendshipScores: friendshipScores,
            );
          },
        ),
      ),
    );
  }
}
