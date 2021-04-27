import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_numbers_utils.dart';
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
  Group _group;
  String _friendFullName;

  void asyncInit() async {
    try {
      Group group = await ServiceProvider.groupsService
          .getGroup(widget.challenge.groupId);

      if (group.binary) {
        String currentUserId =
            await ServiceProvider.usersService.getCurrentUserId();
        String otherUserId =
            group.usersIds.singleWhere((userId) => userId != currentUserId);
        _friendFullName =
            await ServiceProvider.usersService.getUserFullNameById(otherUserId);
      }
      setState(() {});
      _group = group;
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.error),
      ));
    }
  }

  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () async {
        Challenge challenge;
        try {
          challenge = await ServiceProvider.challengesService
              .getChallenge(widget.challenge.id);
        } on ApiException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('${AppLocalizations.of(context).error}: ${e.error}')));
        }
        if (challenge.deadlinePassed()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)
                .theDeadlineHasAlreadyPassedForThisChallenge),
          ));
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
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: (widget.challenge?.motivation?.length ?? 0) != 0,
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
                          child: Icon((_group?.binary ?? false)
                              ? Icons.person
                              : Icons.group),
                        ),
                        Text(_group?.binary ?? false
                            ? '$_friendFullName'
                            : _group?.name ??
                                AppLocalizations.of(context).nameNotFound),
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
          '${AppLocalizations.of(context).endsAfter} ${ArabicNumbersUtils.englishToArabic(minutesLeft.toString())} ${AppLocalizations.of(context).minute}');
    }
    return Text(
        '${AppLocalizations.of(context).endsAfter} ${ArabicNumbersUtils.englishToArabic(widget.challenge.hoursLeft().toString())} ${AppLocalizations.of(context).hour}');
  }

  @override
  bool get wantKeepAlive => true;
}
