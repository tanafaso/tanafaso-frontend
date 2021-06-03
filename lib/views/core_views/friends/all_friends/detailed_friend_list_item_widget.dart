import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:flutter/material.dart';

class DetailedFriendListItemWidget extends StatelessWidget {
  final FriendshipScores friendshipScores;

  DetailedFriendListItemWidget({@required this.friendshipScores});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4.0),
      child: Card(
        margin: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${friendshipScores.friend.firstName} ${friendshipScores.friend.lastName}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 4)),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 8)),
                                        Text(
                                          "@" +
                                              friendshipScores.friend.username,
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          top: 8,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Text(AppLocalizations.of(context).yourFriend),
                                  Padding(padding: EdgeInsets.only(top: 4)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        friendshipScores.friendScore.toString(),
                                        style: TextStyle(
                                          color: getColor(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(AppLocalizations.of(context).you),
                                  Padding(padding: EdgeInsets.only(top: 4)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        friendshipScores.currentUserScore
                                            .toString(),
                                        style: TextStyle(
                                          color: getColor(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateChallengeScreen(
                                                  initiallySelectedFriends: [
                                                    friendshipScores.friend
                                                  ],
                                                  defaultChallengeTarget:
                                                      ChallengeTarget.FRIENDS,
                                                )));
                                  },
                                  child: Card(
                                    color: Theme.of(context).primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.edit),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8)),
                                          Text(
                                            AppLocalizations.of(context)
                                                .challengeThisFriend,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if (friendshipScores.friendScore > friendshipScores.currentUserScore) {
      return Colors.red;
    } else if (friendshipScores.friendScore <
        friendshipScores.currentUserScore) {
      return Colors.green;
    }
    return Colors.yellow.shade700;
  }
}
