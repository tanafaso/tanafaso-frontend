import 'package:azkar/main.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/net/payload/groups/responses/get_group_leaderboard_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatelessWidget {
  final Friend friend;

  FriendScreen({
    @required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(friend.firstName + " " + friend.lastName);

    return FutureBuilder(
        future:
            ServiceProvider.groupsService.getGroupLeaderboard(friend.groupId),
        builder: (BuildContext context,
            AsyncSnapshot<GetGroupLeaderboardResponse> snapshot) {
          if (snapshot.hasData) {
            GetGroupLeaderboardResponse response = snapshot.data;

            if (response.hasError()) {
              return Text(response.error.errorMessage);
            }

            int friendScore = response.userScores
                .firstWhere(
                    (userScore) => userScore.username == friend.username)
                .totalScore;
            int currentUserScore = response.userScores
                .firstWhere(
                    (userScore) => userScore.username != friend.username)
                .totalScore;
            return Scaffold(
              appBar: AppBar(
                title: Text(friend.firstName + " " + friend.lastName),
              ),
              body: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                       alignment: Alignment.centerRight,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${AppLocalizations.of(context).username}: ${friend.username}'),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(friend.firstName +
                                          " " +
                                          friend.lastName),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(friendScore.toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          AppLocalizations.of(context).you),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Text(currentUserScore.toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // TODO(omorsi): Handle error
            return Text('Error');
          } else {
            // TODO(omorsi): Show loader
            return Text(AppLocalizations.of(context).loading);
          }
        });
  }
}
