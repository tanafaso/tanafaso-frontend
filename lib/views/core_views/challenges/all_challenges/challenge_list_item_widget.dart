import 'package:azkar/models/azkar_challenge.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/challenges/all_challenges/challenge_list_item_loading_widget.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_azkar_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_meaning_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_azkar_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_meaning_challenge_screen.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef ChallengeChangedCallback = void Function(AzkarChallenge newChallenge);

class ChallengeListItemWidget extends StatefulWidget {
  final Challenge challenge;
  final Group group;
  final bool showName;
  final ChallengeChangedCallback challengeChangedCallback;
  final bool firstChallengeInList;
  final List<FriendshipScores> friendshipScores;

  ChallengeListItemWidget({
    Key key,
    this.challenge,
    @required this.group,
    this.showName = true,
    @required this.challengeChangedCallback,
    this.firstChallengeInList = false,
    @required this.friendshipScores,
  }) : super(key: key);

  @override
  _ChallengeListItemWidgetState createState() =>
      _ChallengeListItemWidgetState();
}

class _ChallengeListItemWidgetState extends State<ChallengeListItemWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // Note that some of the challenged users may not be friends.
  List<String> _challengedUsersFullNames;
  List<String> _challengedUsersIds;
  bool _binary;
  bool _deleted;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool _showCloneAndDeleteFeatureDiscovery;

  Future<void> getNeededData() async {
    try {
      String currentUserId =
          await ServiceProvider.usersService.getCurrentUserId();
      _challengedUsersFullNames = [];
      _challengedUsersIds = widget.group.usersIds
          .where((userId) => userId != currentUserId)
          .toList();
      for (String friendId in _challengedUsersIds) {
        String friendFullName =
            await ServiceProvider.usersService.getUserFullNameById(friendId);
        _challengedUsersFullNames.add(friendFullName);
      }
      _binary = _challengedUsersIds.length == 1;
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
    }
  }

  @override
  void initState() {
    super.initState();

    _deleted = false;
    _binary = true;
    _challengedUsersFullNames = [];
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (mounted) {
        FeatureDiscovery.discoverFeatures(
          context,
          [Features.CLONE_AND_DELETE],
        );
      }
    });
    _showCloneAndDeleteFeatureDiscovery = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (mounted) {
          setState(() {
            _showCloneAndDeleteFeatureDiscovery = widget.firstChallengeInList;
          });
        }
      });
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
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
              return RawMaterialButton(
                padding: EdgeInsets.all(4),
                onPressed: () => onChallengePressed(),
                elevation: 2.0,
                fillColor: Colors.white,
                child: !_showCloneAndDeleteFeatureDiscovery
                    ? getMainWidget()
                    : DescribedFeatureOverlay(
                        featureId: Features.CLONE_AND_DELETE,
                        overflowMode: OverflowMode.wrapBackground,
                        contentLocation: ContentLocation.below,
                        barrierDismissible: false,
                        backgroundDismissible: false,
                        tapTarget: SlideTransition(
                            position: _offsetAnimation,
                            child: Icon(Icons.double_arrow)),
                        // The widget that will be displayed as the tap target.
                        title: Center(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(0),
                              )),
                              Text(
                                AppLocalizations.of(context)
                                    .deleteAndCopyChallenge,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        description: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(0),
                            )),
                            Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                AppLocalizations.of(context)
                                    .swipeTheChallengeCardToTheRightToDeleteOrCopyAChallenge,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        targetColor: Colors.white,
                        textColor: Colors.black,
                        child: getMainWidget(),
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
              return ChallengeListItemLoadingWidget();
            }
          }),
    );
  }

  Widget getMainWidget() {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4.0),
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
                      .deleteChallenge(widget.challenge.getId());
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
              caption: widget.challenge.challengeType == ChallengeType.AZKAR
                  ? AppLocalizations.of(context).copy
                  : "إضافة",
              color: Colors.green.shade600,
              icon: widget.challenge.challengeType == ChallengeType.AZKAR
                  ? Icons.copy
                  : Icons.add,
              onTap: () => onCopyPressed(),
            ),
          ),
        ),
      ],
      child: IntrinsicHeight(
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                        widget.challenge.getName(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.challenge.challengeType ==
                          ChallengeType.AZKAR &&
                      (widget.challenge?.azkarChallenge?.motivation?.length ??
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
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        child: Text(
                          widget.challenge.azkarChallenge?.motivation ?? "",
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
                          padding: const EdgeInsets.only(left: 8.0),
                          child: getFriendProgressOnChallengeIcon(),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 3 / 4,
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
    );
  }

  void onAzkarChallengePressed() async {
    AzkarChallenge challenge;
    try {
      challenge = await ServiceProvider.challengesService
          .getAzkarChallenge(widget.challenge.getId());
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
          context, '${AppLocalizations.of(context).error}: ${e.error}');
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DoAzkarChallengeScreen(
            challenge: challenge,
            group: widget.group,
            challengedUsersIds: _challengedUsersIds,
            challengedUsersFullNames: _challengedUsersFullNames,
            friendshipScores: widget.friendshipScores,
            challengeChangedCallback: (changedChallenge) {
              widget.challengeChangedCallback(changedChallenge);
            })));
  }

  void onMeaningChallengePressed() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DoMeaningChallengeScreen(
            challenge: widget.challenge.meaningChallenge,
            group: widget.group,
            challengedUsersIds: _challengedUsersIds,
            challengedUsersFullNames: _challengedUsersFullNames,
            friendshipScores: widget.friendshipScores,
            challengeChangedCallback: (changedChallenge) {
              widget.challengeChangedCallback(changedChallenge);
            })));
  }

  void onChallengePressed() {
    if (widget.challenge.challengeType == ChallengeType.AZKAR) {
      onAzkarChallengePressed();
    } else {
      onMeaningChallengePressed();
    }
  }

  void onCopyAzkarChallenge() async {
    // Get original challenge
    AzkarChallenge originalChallenge;
    try {
      originalChallenge = await ServiceProvider.challengesService
          .getOriginalChallenge(widget.challenge.getId());
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
        context,
        '${AppLocalizations.of(context).error}: ${e.error}',
      );
      return;
    }
    Friendship friends = await ServiceProvider.usersService.getFriends();
    List<Friend> currentChallengeFriends = friends.friends
        .where((friend) => _challengedUsersIds.contains(friend.userId))
        .toList();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateAzkarChallengeScreen(
                  initiallySelectedFriends: currentChallengeFriends,
                  initiallySelectedSubChallenges:
                      originalChallenge.subChallenges,
                  initiallyChosenName: originalChallenge.name,
                  initiallyChosenMotivation: originalChallenge.motivation,
                )));
  }

  void onCopyMeaningChallenge() async {
    Friendship friends = await ServiceProvider.usersService.getFriends();
    List<Friend> currentChallengeFriends = friends.friends
        .where((friend) => _challengedUsersIds.contains(friend.userId))
        .toList();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateMeaningChallengeScreen(
                  initiallySelectedFriends: currentChallengeFriends,
                )));
  }

  void onCopyPressed() {
    if (widget.challenge.challengeType == ChallengeType.AZKAR) {
      onCopyAzkarChallenge();
    } else {
      onCopyMeaningChallenge();
    }
  }

  Widget getFriendsNames() {
    String text;
    if (!widget.showName) {
      text = AppLocalizations.of(context).yourFriend;
    } else if (_binary) {
      text = _challengedUsersFullNames[0];
    } else {
      assert(_challengedUsersFullNames.length > 0);
      List<String> friendsFullNamesCopy =
          new List<String>.from(_challengedUsersFullNames);
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

    if (widget.challenge
        .getUsersFinishedIds()
        .any((userFinished) => userFinished == _challengedUsersIds[0])) {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
