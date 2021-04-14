import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/payload/challenges/responses/get_challenge_response.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/service_provider.dart';
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
    extends State<GroupChallengeListItemWidget> {
  Group _group;
  User _friend;

  @override
  void initState() {
    ServiceProvider.groupsService
        .getGroup(widget.challenge.groupId)
        .then((getGroupResponse) async {
      if (getGroupResponse.hasError()) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getGroupResponse.error.errorMessage),
        ));
        return;
      }

      if (getGroupResponse.group.binary) {
        GetUserResponse currentUserResponse =
            await ServiceProvider.usersService.getCurrentUser();
        String otherUserId = getGroupResponse.group.usersIds
            .singleWhere((userId) => userId != currentUserResponse.user.id);
        GetUserResponse otherUserResponse =
            await ServiceProvider.usersService.getUserById(otherUserId);
        _friend = otherUserResponse.user;
      }

      _group = getGroupResponse.group;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        GetChallengeResponse response = await ServiceProvider.challengesService
            .getChallenge(widget.challenge.id);
        if (response.hasError()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  '${AppLocalizations.of(context).error}: ${response.error.errorMessage}')));
          return;
        }
        if (response.challenge.deadlinePassed()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)
                .theDeadlineHasAlreadyPassedForThisChallenge),
          ));
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DoChallengeScreen(
                challenge: response.challenge,
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
                            ? '${_friend.firstName} ${_friend.lastName}'
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
            '${AppLocalizations.of(context).endsAfterLessThan} 1 ${AppLocalizations.of(context).minute}');
      }
      return Text(
          '${AppLocalizations.of(context).endsAfter} $minutesLeft ${AppLocalizations.of(context).minute}');
    }
    return Text(
        '${AppLocalizations.of(context).endsAfter} ${widget.challenge.hoursLeft()} ${AppLocalizations.of(context).hour}');
  }
}
