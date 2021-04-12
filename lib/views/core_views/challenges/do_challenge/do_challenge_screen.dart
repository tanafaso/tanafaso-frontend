import 'package:azkar/main.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/group.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_list_item_widget.dart';
import 'package:flutter/material.dart';

class DoChallengeScreen extends StatefulWidget {
  final Challenge challenge;

  DoChallengeScreen(this.challenge);

  @override
  _DoChallengeScreenState createState() => _DoChallengeScreenState();
}

class _DoChallengeScreenState extends State<DoChallengeScreen> {
  Group _group;
  User _friend;
  bool _isPersonalChallenge = false;

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
        String otherUserId = getGroupResponse.group.usersIds.singleWhere(
            (userId) => userId != currentUserResponse.user.id,
            orElse: null);
        _isPersonalChallenge = otherUserId == null;
        if (otherUserId != null) {
          GetUserResponse otherUserResponse =
              await ServiceProvider.usersService.getUserById(otherUserId);
          _friend = otherUserResponse.user;
        }
      }

      _group = getGroupResponse.group;
      setState(() {});
    });

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
                  visible: !_isPersonalChallenge && _group != null,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon((_group?.binary ?? false)
                            ? Icons.person
                            : Icons.group),
                      ),
                      Text(_group?.binary ?? false
                          ? _friend?.username ??
                              AppLocalizations.of(context).nameNotFound
                          : _group?.name ??
                              AppLocalizations.of(context).nameNotFound),
                    ],
                  ),
                ),
              ),
              Card(
                child: Visibility(
                  visible: (widget.challenge.motivation?.length ?? 0) != 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.directions_run),
                      ),
                      Text(widget.challenge.motivation),
                    ],
                  ),
                ),
              ),
              Card(
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
          callback: (SubChallenge newSubChallenge) {
            widget.challenge.subChallenges[index] = newSubChallenge;
            ServiceProvider.challengesService
                .updateChallenge(widget.challenge)
                .then((response) {
              if (response.hasError()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response.error.errorMessage),
                ));
              }
            }, onError: (error) {
              // TODO(omorsi): Print something useful if an error occurred.
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(response.error.errorMessage),
              // ));
            });

            if (widget.challenge.done()) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)
                    .youHaveFinishedTheChallengeSuccessfully),
                backgroundColor: Colors.green.shade400,
              ));
            }
          },
        );
      },
    );
  }
}
