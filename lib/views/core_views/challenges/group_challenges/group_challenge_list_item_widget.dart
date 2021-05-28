import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef ChallengeChangedCallback = void Function(Challenge newChallenge);

class GroupChallengeListItemWidget extends StatefulWidget {
  final Challenge challenge;
  final Group group;
  final bool showName;
  final ChallengeChangedCallback challengeChangedCallback;

  GroupChallengeListItemWidget({
    @required this.challenge,
    @required this.group,
    this.showName = true,
    @required this.challengeChangedCallback,
  });

  @override
  _GroupChallengeListItemWidgetState createState() =>
      _GroupChallengeListItemWidgetState();
}

class _GroupChallengeListItemWidgetState
    extends State<GroupChallengeListItemWidget>
    with AutomaticKeepAliveClientMixin {
  List<String> _friendsFullNames;
  List<String> _friendsIds;
  bool _binary;
  bool _deleted;

  Future<void> getNeededData() async {
    try {
      String currentUserId =
          await ServiceProvider.usersService.getCurrentUserId();
      _friendsFullNames = [];
      _friendsIds = widget.group.usersIds
          .where((userId) => userId != currentUserId)
          .toList();
      for (String friendId in _friendsIds) {
        String friendFullName =
            await ServiceProvider.usersService.getUserFullNameById(friendId);
        _friendsFullNames.add(friendFullName);
      }
      _binary = _friendsIds.length == 1;
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
    }
  }

  @override
  void initState() {
    super.initState();

    _deleted = false;
    _binary = true;
    _friendsFullNames = [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Visibility(
      visible: !_deleted,
      maintainSize: false,
      maintainState: false,
      child: FutureBuilder(
          future: getNeededData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                onTap: () async {
                  Challenge challenge;
                  try {
                    challenge = await ServiceProvider.challengesService
                        .getChallenge(widget.challenge.id);
                  } on ApiException catch (e) {
                    SnackBarUtils.showSnackBar(context,
                        '${AppLocalizations.of(context).error}: ${e.error}');
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DoChallengeScreen(
                          challenge: challenge,
                          group: widget.group,
                          friendsIds: _friendsIds,
                          friendsFullNames: _friendsFullNames,
                          isPersonalChallenge: false,
                          challengeChangedCallback: (changedChallenge) {
                            widget.challengeChangedCallback(changedChallenge);
                          })));
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, top: 4.0, right: 4.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        child: IconSlideAction(
                          caption: AppLocalizations.of(context).delete,
                          foregroundColor: Colors.white,
                          color: Colors.red.shade400,
                          iconWidget: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                          ),
                          onTap: () async {
                            try {
                              await ServiceProvider.challengesService
                                  .deleteChallenge(widget.challenge.id);
                              setState(() {
                                _deleted = true;
                              });
                              SnackBarUtils.showSnackBar(
                                  context,
                                  AppLocalizations.of(context)
                                      .theChallengeHasBeenDeletedSuccessfully,
                                  color: Colors.green);
                            } on ApiException catch (e) {
                              SnackBarUtils.showSnackBar(
                                context,
                                '${AppLocalizations.of(context).error}: ${e.error}',
                              );
                              return;
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        child: IconSlideAction(
                          caption: AppLocalizations.of(context).copy,
                          color: Colors.green.shade600,
                          icon: Icons.copy,
                          onTap: () async {
                            // Get original challenge
                            Challenge challenge = await ServiceProvider
                                .challengesService
                                .getOriginalChallenge(widget.challenge.id);
                            Friendship friends =
                                await ServiceProvider.usersService.getFriends();
                            List<Friend> currentChallengeFriends = friends
                                .friends
                                .where((friend) =>
                                    _friendsIds.contains(friend.userId))
                                .toList();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateChallengeScreen(
                                          initiallySelectedFriends:
                                              currentChallengeFriends,
                                          initiallySelectedSubChallenges:
                                              challenge.subChallenges,
                                          initiallyChosenName: challenge.name,
                                          initiallyChosenMotivation:
                                              challenge.motivation,
                                          defaultChallengeTarget:
                                              ChallengeTarget.FRIENDS,
                                        )));
                          },
                        ),
                      ),
                    ),
                  ],
                  child: Card(
                    margin: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: getIconConditionally(),
                            ),
                          ),
                          VerticalDivider(
                            width: 3,
                            color: Colors.black,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.challenge.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible:
                                    (widget.challenge?.motivation?.length ??
                                            0) !=
                                        0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.directions_run),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          2 /
                                          3,
                                      child: Text(
                                        widget.challenge.motivation,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.alarm),
                                  ),
                                  getDeadlineText(context),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible: _binary,
                                      maintainSize: false,
                                      maintainState: false,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child:
                                            getFriendProgressOnChallengeIcon(),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          3 /
                                          4,
                                      child: getFriendsNames(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SnapshotUtils.getErrorWidget(context, snapshot),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                            '${AppLocalizations.of(context).loadingTheChallenge}...'),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget getFriendsNames() {
    String text;
    if (!widget.showName) {
      text = AppLocalizations.of(context).yourFriend;
    } else if (_binary) {
      text = _friendsFullNames[0];
    } else {
      assert(_friendsFullNames.length > 0);
      List<String> friendsFullNamesCopy =
          new List<String>.from(_friendsFullNames);
      friendsFullNamesCopy.shuffle();
      String otherOrOthers = friendsFullNamesCopy.length - 2 > 1
          ? AppLocalizations.of(context).others
          : AppLocalizations.of(context).other;
      text = friendsFullNamesCopy.length - 2 == 0
          ? '${friendsFullNamesCopy[0]} ،${friendsFullNamesCopy[1]}'
          : '${friendsFullNamesCopy[0]} ،${friendsFullNamesCopy[1]} ${AppLocalizations.of(context).and} ${ArabicUtils.englishToArabic((friendsFullNamesCopy.length - 2).toString())} $otherOrOthers';
    }
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getFriendProgressOnChallengeIcon() {
    if (!_binary) {
      return Container();
    }

    if (widget.challenge.usersFinished
        .any((userFinished) => userFinished == _friendsIds[0])) {
      return Icon(
        Icons.done_outline,
        size: 15,
        color: Colors.green,
      );
    }

    if (widget.challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        size: 15,
        color: Colors.red,
      );
    }

    return Icon(
      Icons.not_started,
      size: 15,
      color: Colors.yellow,
    );
  }

  Widget getIconConditionally() {
    if (widget.challenge.done()) {
      return Icon(
        Icons.done_outline,
        color: Colors.green,
      );
    }
    if (widget.challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
      );
    }
    return Icon(
      Icons.not_started,
      color: Colors.yellow,
    );
  }

  Widget getDeadlineText(BuildContext context) {
    if (widget.challenge.deadlinePassed()) {
      return Text(AppLocalizations.of(context).passed);
    }
    int hoursLeft = widget.challenge.hoursLeft();
    if (hoursLeft == 0) {
      int minutesLeft = widget.challenge.minutesLeft();
      if (minutesLeft == 0) {
        return Text(
            '${AppLocalizations.of(context).endsAfterLessThan} ١ ${AppLocalizations.of(context).minute}');
      }
      return Text(
          '${AppLocalizations.of(context).endsAfter} ${ArabicUtils.englishToArabic(minutesLeft.toString())} ${AppLocalizations.of(context).minute}');
    }
    return Text(
        '${AppLocalizations.of(context).endsAfter} ${ArabicUtils.englishToArabic(widget.challenge.hoursLeft().toString())} ${AppLocalizations.of(context).hour}');
  }

  @override
  bool get wantKeepAlive => true;
}
