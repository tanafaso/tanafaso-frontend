import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_screen.dart';
import 'package:flutter/material.dart';

typedef ChallengeChangedCallback = void Function(Challenge newChallenge);

class GroupChallengeListItemWidget extends StatefulWidget {
  final Challenge challenge;
  final bool showName;
  final ChallengeChangedCallback challengeChangedCallback;

  GroupChallengeListItemWidget(
      {@required this.challenge,
      this.showName = true,
      @required this.challengeChangedCallback});

  @override
  _GroupChallengeListItemWidgetState createState() =>
      _GroupChallengeListItemWidgetState();
}

class _GroupChallengeListItemWidgetState
    extends State<GroupChallengeListItemWidget>
    with AutomaticKeepAliveClientMixin {
  CachedGroupInfo _group;
  String _friendFullName;
  String _friendId;

  Future<void> getNeededData() async {
    try {
      _group = await ServiceProvider.groupsService
          .getCachedGroupInfo(widget.challenge.groupId);

      if (_group.binary) {
        String currentUserId =
            await ServiceProvider.usersService.getCurrentUserId();
        _friendId =
            _group.usersIds.singleWhere((userId) => userId != currentUserId);
        _friendFullName =
            await ServiceProvider.usersService.getUserFullNameById(_friendId);
      }
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
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
                if (challenge.deadlinePassed()) {
                  SnackBarUtils.showSnackBar(
                      context,
                      AppLocalizations.of(context)
                          .theDeadlineHasAlreadyPassedForThisChallenge);
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DoChallengeScreen(
                        challenge: challenge,
                        isPersonalChallenge: false,
                        challengeChangedCallback: (changedChallenge) {
                          widget.challengeChangedCallback(changedChallenge);
                        })));
              },
              child: Card(
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getIconConditionally(),
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
                                (widget.challenge?.motivation?.length ?? 0) !=
                                    0,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.directions_run),
                                ),
                                Text(
                                  widget.challenge.motivation,
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
                          Visibility(
                            visible: _group != null && widget.showName,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getFriendProgressOnChallengeIcon(),
                                ),
                                Text(_group?.binary ?? false
                                    ? '$_friendFullName'
                                    : _group?.name ??
                                        AppLocalizations.of(context)
                                            .nameNotFound),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _group != null && !widget.showName,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getFriendProgressOnChallengeIcon(),
                                ),
                                Text(AppLocalizations.of(context).yourFriend),
                              ],
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
        });
  }

  // Note: This skews the idea of having this widget ready for group challenges.
  Widget getFriendProgressOnChallengeIcon() {
    if (widget.challenge.usersFinished
        .any((userFinished) => userFinished == _friendId)) {
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
