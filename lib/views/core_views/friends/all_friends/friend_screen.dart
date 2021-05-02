import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/user_score.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  final Friend friend;

  FriendScreen({
    @required this.friend,
  });

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(
        widget.friend.firstName + " " + widget.friend.lastName);

    return FutureBuilder(
        future: ServiceProvider.groupsService
            .getGroupLeaderboard(widget.friend.groupId),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserScore>> snapshot) {
          if (snapshot.hasData) {
            int friendScore = snapshot.data
                .firstWhere(
                    (userScore) => userScore.username == widget.friend.username)
                .totalScore;
            int currentUserScore = snapshot.data
                .firstWhere(
                    (userScore) => userScore.username != widget.friend.username)
                .totalScore;

            Color friendColor;
            Color currentUserColor;
            if (friendScore == currentUserScore) {
              friendColor = Colors.yellow;
              currentUserColor = Colors.yellow;
            } else if (friendScore > currentUserScore) {
              friendColor = Colors.green;
              currentUserColor = Color(0XFFdd5454);
            } else {
              friendColor = Color(0XFFdd5454);
              currentUserColor = Colors.green;
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    widget.friend.firstName + " " + widget.friend.lastName),
              ),
              body: Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.friend.username),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Card(
                                color: friendColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context)
                                            .yourFriend),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(friendScore.toString()),
                                          ),
                                          Icon(
                                            Icons.done_all,
                                            // color: Colors.green,
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
                                color: currentUserColor,
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                currentUserScore.toString()),
                                          ),
                                          Icon(
                                            Icons.done_all,
                                            // color: Colors.green,
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
                        Divider(
                          thickness: 3,
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context).theChallenges,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: getChallengesListWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                  heroTag: "mainFloating",
                  icon: Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).challengeThisFriend),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateChallengeScreen(
                              selectedFriend: widget.friend,
                            defaultChallengeTarget: ChallengeTarget.FRIEND,
                            )));
                    setState(() {});
                  }),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                      widget.friend.firstName + " " + widget.friend.lastName),
                ),
                body: Center(
                  child: SnapshotUtils.getErrorWidget(context, snapshot),
                ));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    widget.friend.firstName + " " + widget.friend.lastName),
              ),
              body: Center(
                child: Text(AppLocalizations.of(context).loading),
              ),
              floatingActionButton: FloatingActionButton.extended(
                  heroTag: "mainFloating",
                  icon: Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).challengeThisFriend),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateChallengeScreen(
                              selectedFriend: widget.friend,
                              defaultChallengeTarget: ChallengeTarget.FRIEND,
                            )));
                    setState(() {});
                  }),
            );
          }
        });
  }

  Widget getChallengesListWidget() {
    return FutureBuilder(
        future: ServiceProvider.groupsService
            .getAllChallengesInGroup(widget.friend.groupId),
        builder:
            (BuildContext context, AsyncSnapshot<List<Challenge>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GroupChallengeListItemWidget(
                  challenge: snapshot.data[index],
                  showName: false,
                  challengeChangedCallback: (_) {
                    setState(() {});
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return SnapshotUtils.getErrorWidget(context, snapshot);
          } else {
            // TODO(omorsi): Show loader
            return Text(AppLocalizations.of(context).loading);
          }
        });
  }
}
