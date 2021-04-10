import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:flutter/material.dart';

class AllChallengesListItemWidget extends StatefulWidget {
  final Challenge challenge;

  AllChallengesListItemWidget({@required this.challenge});

  @override
  _AllChallengesListItemWidgetState createState() =>
      _AllChallengesListItemWidgetState();
}

class _AllChallengesListItemWidgetState
    extends State<AllChallengesListItemWidget> {
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
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getIconConditionally(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${AppLocalizations.of(context).name}:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text(
                    widget.challenge.name,
                  ),
                ],
              ),
              Visibility(
                visible: (widget.challenge?.motivation?.length ?? 0) != 0,
                child: Row(
                  children: [
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${AppLocalizations.of(context).motivation}:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(
                      widget.challenge.motivation,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${AppLocalizations.of(context).deadline}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  getDeadlineText(context),
                ],
              ),
              Visibility(
                visible: _group != null,
                child: Row(
                  children: [
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _group?.binary ?? false
                              ? '${AppLocalizations.of(context).theFriend}:'
                              : '${AppLocalizations.of(context).theGroup}:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(_group?.binary ?? false
                        ? _friend?.username ??
                            AppLocalizations.of(context).nameNotFound
                        : _group?.name ??
                            AppLocalizations.of(context).nameNotFound),
                  ],
                ),
              ),
            ],
          ),
        ],
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
            '${AppLocalizations.of(context).endsAfterLessThan} $minutesLeft ${AppLocalizations.of(context).minutes}');
      }
      return Text(
          '${AppLocalizations.of(context).endsAfter} $minutesLeft ${AppLocalizations.of(context).minutes}');
    }
    return Text(
        '${AppLocalizations.of(context).endsAfter} ${widget.challenge.hoursLeft()} ${AppLocalizations.of(context).hours}');
  }
}
