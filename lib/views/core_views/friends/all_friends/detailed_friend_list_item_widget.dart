import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:flutter/material.dart';

typedef OnToggleViewCallback = void Function();
typedef OnFriendDeletedCallback = void Function();

class DetailedFriendListItemWidget extends StatelessWidget {
  final FriendshipScores friendshipScores;
  final OnToggleViewCallback toggleViewCallback;
  final OnFriendDeletedCallback onFriendDeletedCallback;

  DetailedFriendListItemWidget({
    @required this.friendshipScores,
    @required this.toggleViewCallback,
    @required this.onFriendDeletedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggleViewCallback.call(),
      child: Padding(
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
                                              padding:
                                                  EdgeInsets.only(left: 8)),
                                          Text(
                                            "@" +
                                                friendshipScores
                                                    .friend.username,
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.grey.shade700),
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
                                    Text(AppLocalizations.of(context)
                                        .yourFriend),
                                    Padding(padding: EdgeInsets.only(top: 4)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          friendshipScores.friendScore
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
                              Flexible(
                                child: Column(
                                  children: [
                                    Text(AppLocalizations.of(context).you),
                                    Padding(padding: EdgeInsets.only(top: 4)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          MaterialButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CreateChallengeScreen(
                                          initiallySelectedFriends: [
                                            friendshipScores.friend
                                          ],
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit_outlined),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Text(
                                      AppLocalizations.of(context)
                                          .challengeThisFriend,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )),
                          Visibility(
                            visible:
                                friendshipScores.friend.username != "sabeq",
                            child: MaterialButton(
                                color: Colors.grey,
                                onPressed: () async {
                                  bool deleted =
                                      await _showDeleteFriendAlertDialog(
                                          context);
                                  if (deleted) {
                                    onFriendDeletedCallback.call();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 8)),
                                      Text(
                                        "حذف هذا الصديق",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
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
      ),
    );
  }

  Future<bool> _showDeleteFriendAlertDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف صديق'),
          content: SingleChildScrollView(
            child: Text('هل تريد حقا حذف هذا الصديق؟'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('نعم'),
              onPressed: () async {
                try {
                  await ServiceProvider.usersService
                      .deleteFriend(friendshipScores.friend.userId);
                } on ApiException catch (e) {
                  SnackBarUtils.showSnackBar(context, e.error);
                }
                Navigator.of(context).pop(/*deleted=*/ true);
              },
            ),
            TextButton(
              child: const Text('لا'),
              onPressed: () {
                Navigator.of(context).pop(/*deleted=*/ false);
              },
            ),
          ],
        );
      },
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
