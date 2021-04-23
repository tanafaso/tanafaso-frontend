import 'package:azkar/main.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenges_response.dart';
import 'package:azkar/net/payload/groups/responses/get_group_leaderboard_response.dart';
import 'package:azkar/net/service_provider.dart';
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
        builder: (BuildContext context,
            AsyncSnapshot<GetGroupLeaderboardResponse> snapshot) {
          if (snapshot.hasData) {
            GetGroupLeaderboardResponse response = snapshot.data;
            if (response.hasError()) {
              return Text(response.error.errorMessage);
            }

            int friendScore = response.userScores
                .firstWhere(
                    (userScore) => userScore.username == widget.friend.username)
                .totalScore;
            int currentUserScore = response.userScores
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
                            )));
                    setState(() {});
                  }),
            );
          } else if (snapshot.hasError) {
            // TODO(omorsi): Handle error
            return Text('Error');
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
        builder: (BuildContext context,
            AsyncSnapshot<GetChallengesResponse> snapshot) {
          if (snapshot.hasData) {
            GetChallengesResponse response = snapshot.data;
            if (response.hasError()) {
              return Text(response.error.errorMessage);
            }
            return ListView.builder(
              itemCount: response.challenges.length,
              itemBuilder: (context, index) {
                return GroupChallengeListItemWidget(
                  challenge: response.challenges[index],
                  showName: false,
                  challengeChangedCallback: (_) {
                    setState(() {});
                  },
                );
              },
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
