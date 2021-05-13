import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/friend_screen.dart';
import 'package:flutter/material.dart';

class DoChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;
  final bool isPersonalChallenge;

  DoChallengeScreen(
      {@required this.challenge,
      @required this.challengeChangedCallback,
      @required this.isPersonalChallenge});

  @override
  _DoChallengeScreenState createState() => _DoChallengeScreenState();
}

class _DoChallengeScreenState extends State<DoChallengeScreen> {
  Group _group;
  User _friend;

  void asyncInit() async {
    if (!widget.isPersonalChallenge) {
      try {
        Group group = await ServiceProvider.groupsService
            .getGroup(widget.challenge.groupId);

        if (group.binary) {
          String currentUserId =
              await ServiceProvider.usersService.getCurrentUserId();
          String otherUserId = group.usersIds
              .singleWhere((userId) => userId != currentUserId, orElse: null);
          if (otherUserId != null) {
            _friend =
                await ServiceProvider.usersService.getUserById(otherUserId);
          }
        }

        _group = group;
      } on ApiException catch (e) {
        SnackBarUtils.showSnackBar(context, e.error);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    asyncInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.challenge.name),
        ),
        body: Center(
          child: Column(
            children: [
              Card(
                child: Visibility(
                  visible: !widget.isPersonalChallenge && _group != null,
                  child: GestureDetector(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon((_group?.binary ?? false)
                              ? Icons.person
                              : Icons.group),
                        ),
                        Text(_group?.binary ?? false
                            ? _friend.firstName + " " + _friend.lastName
                            : _group?.name ??
                                AppLocalizations.of(context).nameNotFound),
                      ],
                    ),
                    onTapDown: (_) {
                      if ((_group.binary ?? false)) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FriendScreen(
                                  friend: Friend(
                                    userId: _friend.id,
                                    groupId: _group.id,
                                    username: _friend.username,
                                    firstName: _friend.firstName,
                                    lastName: _friend.lastName,
                                    pending: false,
                                  ),
                                )));
                      }
                    },
                  ),
                ),
              ),
              Card(
                child: Visibility(
                  visible: (widget.challenge.motivation?.length ?? 0) != 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.directions_run),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: Text(
                            widget.challenge.motivation,
                            softWrap: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !widget.challenge.done(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .clickOnZekrAfterReadingIt,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ))),
                ),
              ),
              Expanded(
                  child: Container(
                child: getSubChallenges(),
              )),
            ],
          ),
        ));
  }

  Widget getSubChallenges() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.challenge.subChallenges.length,
      itemBuilder: (context, index) {
        return DoChallengeSubChallengeListItemWidget(
          subChallenge: widget.challenge.subChallenges[index],
          challenge: widget.challenge,
          callback: (SubChallenge newSubChallenge) async {
            widget.challenge.subChallenges[index] = newSubChallenge;
            try {
              widget.isPersonalChallenge
                  ? await ServiceProvider.challengesService
                      .updatePersonalChallenge(widget.challenge)
                  : await ServiceProvider.challengesService
                      .updateChallenge(widget.challenge);
            } on ApiException catch (e) {
              SnackBarUtils.showSnackBar(context, e.error);
            }

            widget.challengeChangedCallback(widget.challenge);
            if (widget.challenge.done()) {
              Navigator.of(context).pop();
              SnackBarUtils.showSnackBar(
                  context,
                  AppLocalizations.of(context)
                      .youHaveFinishedTheChallengeSuccessfully,
                  color: Colors.green.shade400);
            }
          },
        );
      },
    );
  }
}
