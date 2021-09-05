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
import 'package:azkar/views/core_views/challenges/create_challenge/create_quran_reading_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_azkar_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_meaning_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_reading_quran_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/friends_progress_widget.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
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

  Future<void> _neededData;

  @override
  void initState() {
    _neededData = getNeededData();
    _deleted = false;
    _binary = true;
    _challengedUsersFullNames = [];
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Visibility(
      visible: !_deleted,
      maintainSize: false,
      maintainState: false,
      child: FutureBuilder(
          future: _neededData,
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
              caption: getCopyCaption(),
              color: Colors.green.shade600,
              icon: getCopyIcon(),
              onTap: () => onCopyPressed(),
            ),
          ),
        ),
      ],
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 8)),
                getIcon(),
                Padding(padding: EdgeInsets.only(right: 8)),
                Text(
                  widget.challenge.getName(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return FriendsProgressWidget(
                            challenge: widget.challenge,
                            challengedUsersIds: _challengedUsersIds,
                            challengedUsersFullNames: _challengedUsersFullNames,
                            fontSize: 20,
                          );
                        });
                  },
                  child: Icon(
                    Icons.whatshot,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [],
                  ),
                  Visibility(
                    visible: widget.challenge.challengeType ==
                            ChallengeType.AZKAR &&
                        (widget.challenge?.azkarChallenge?.motivation?.length ??
                                0) !=
                            0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      child: Text(
                        widget.challenge.azkarChallenge?.motivation ?? "",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  getDeadlineText(context),
                  Container(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: getFriendsNames(),
                  ),
                ],
              ),
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

  void onReadingChallengePressed() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DoReadingQuranChallengeScreen(
            challenge: widget.challenge.readingQuranChallenge,
            group: widget.group,
            challengedUsersIds: _challengedUsersIds,
            challengedUsersFullNames: _challengedUsersFullNames,
            friendshipScores: widget.friendshipScores,
            challengeChangedCallback: (changedChallenge) {
              widget.challengeChangedCallback(changedChallenge);
            })));
  }

  void onChallengePressed() {
    switch (widget.challenge.challengeType) {
      case ChallengeType.AZKAR:
        onAzkarChallengePressed();
        return;
      case ChallengeType.MEANING:
        onMeaningChallengePressed();
        return;
      case ChallengeType.READING_QURAN:
        onReadingChallengePressed();
        return;
      case ChallengeType.OTHER:
        return;
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

  void onCopyReadingChallenge() async {
    Friendship friends = await ServiceProvider.usersService.getFriends();
    List<Friend> currentChallengeFriends = friends.friends
        .where((friend) => _challengedUsersIds.contains(friend.userId))
        .toList();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateQuranReadingChallengeScreen(
                  initiallySelectedFriends: currentChallengeFriends,
                  initiallySelectedSurahSubChallenges:
                      widget.challenge.readingQuranChallenge.surahSubChallenges,
                )));
  }

  String getCopyCaption() {
    return widget.challenge.challengeType == ChallengeType.AZKAR ||
            widget.challenge.challengeType == ChallengeType.READING_QURAN ||
            widget.challenge.challengeType == ChallengeType.OTHER
        ? AppLocalizations.of(context).copy
        : "إضافة";
  }

  IconData getCopyIcon() {
    return widget.challenge.challengeType == ChallengeType.AZKAR ||
            widget.challenge.challengeType == ChallengeType.READING_QURAN ||
            widget.challenge.challengeType == ChallengeType.OTHER
        ? Icons.copy
        : Icons.add;
  }

  void onCopyPressed() {
    switch (widget.challenge.challengeType) {
      case ChallengeType.AZKAR:
        onCopyAzkarChallenge();
        return;
      case ChallengeType.MEANING:
        onCopyMeaningChallenge();
        return;
      case ChallengeType.READING_QURAN:
        onCopyReadingChallenge();
        return;
      case ChallengeType.OTHER:
        return;
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

    return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(
                text: "تنافس مع ",
                style: new TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
            new TextSpan(
              text: text,
            ),
          ],
        ));
  }

  Widget getIcon() {
    if (widget.challenge.done()) {
      return Icon(
        Icons.done_outline,
        color: Colors.green,
        size: 20,
      );
    }
    if (widget.challenge.deadlinePassed()) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 20,
      );
    }
    return Icon(
      Icons.not_started,
      color: Colors.yellow,
      size: 25,
    );
  }

  Widget getDeadlineText(BuildContext context) {
    if (widget.challenge.deadlinePassed()) {
      return Text(
        "انتهى التحدي",
        style: new TextStyle(
            color: Colors.grey.shade700, fontWeight: FontWeight.bold),
      );
    }
    int hoursLeft = widget.challenge.hoursLeft();
    if (hoursLeft == 0) {
      int minutesLeft = widget.challenge.minutesLeft();
      if (minutesLeft == 0) {
        return RichText(
            text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(
                text: AppLocalizations.of(context).endsAfterLessThan,
                style: new TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
            new TextSpan(
              text: ' ١ ',
            ),
            new TextSpan(
              text: AppLocalizations.of(context).minute,
            )
          ],
        ));
      }
      return RichText(
          text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: AppLocalizations.of(context).endsAfter,
              style: new TextStyle(
                  color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
          new TextSpan(
            text: ' ${ArabicUtils.englishToArabic(minutesLeft.toString())} ',
          ),
          new TextSpan(
            text: AppLocalizations.of(context).minute,
          )
        ],
      ));
    }
    return RichText(
        text: TextSpan(
      style: TextStyle(
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(
            text: AppLocalizations.of(context).endsAfter,
            style: new TextStyle(
                color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
        new TextSpan(
          text:
              ' ${ArabicUtils.englishToArabic(widget.challenge.hoursLeft().toString())} ',
        ),
        new TextSpan(
          text: AppLocalizations.of(context).hour,
        )
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
