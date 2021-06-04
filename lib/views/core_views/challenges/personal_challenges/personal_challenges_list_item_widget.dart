import 'package:azkar/models/challenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_challenge_screen.dart';
import 'package:azkar/views/core_views/challenges/group_challenges/group_challenge_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PersonalChallengesListItemWidget extends StatefulWidget {
  final Challenge challenge;
  final ChallengeChangedCallback challengeChangedCallback;

  PersonalChallengesListItemWidget(
      {@required this.challenge, @required this.challengeChangedCallback});

  @override
  _PersonalChallengesListItemWidgetState createState() =>
      _PersonalChallengesListItemWidgetState();
}

class _PersonalChallengesListItemWidgetState
    extends State<PersonalChallengesListItemWidget> {
  bool _deleted;

  @override
  void initState() {
    super.initState();
    _deleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_deleted,
      maintainState: false,
      maintainSize: false,
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DoChallengeScreen(
                  challenge: widget.challenge,
                  isPersonalChallenge: true,
                  challengeChangedCallback: (changedChallenge) {
                    widget.challengeChangedCallback.call(changedChallenge);
                  })));
        },
        child: Slidable(
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
                          .deletePersonalChallenge(widget.challenge.id);
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
                    Challenge original;
                    try {
                      original = await ServiceProvider.challengesService
                          .getOriginalChallenge(widget.challenge.id);
                    } on ApiException catch (e) {
                      SnackBarUtils.showSnackBar(
                        context,
                        '${AppLocalizations.of(context).error}: ${e.error}',
                      );
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateChallengeScreen(
                                  initiallySelectedSubChallenges:
                                      original.subChallenges,
                                  initiallyChosenName: original.name,
                                  initiallyChosenMotivation:
                                      original.motivation,
                                  defaultChallengeTarget: ChallengeTarget.SELF,
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
                          visible:
                              (widget.challenge?.motivation?.length ?? 0) != 0,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.directions_run),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                child: Text(
                                  widget.challenge.motivation,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !widget.challenge.done() &&
                              !widget.challenge.deadlinePassed(),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.alarm),
                              ),
                              getDeadlineText(context),
                            ],
                          ),
                        ),
                      ]),
                ],
              ),
            ),
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
          '${AppLocalizations.of(context).endsAfter} ${ArabicUtils.englishToArabic(minutesLeft.toString())} ${AppLocalizations.of(context).minute}');
    } else {
      int minutes =
          widget.challenge.minutesLeft() - widget.challenge.hoursLeft() * 60;
      return Text(
          '${AppLocalizations.of(context).endsAfter} ${ArabicUtils.englishToArabic(widget.challenge.hoursLeft().toString())} ${AppLocalizations.of(context).hour} ${AppLocalizations.of(context).and} ${ArabicUtils.englishToArabic(minutes.toString())} ${AppLocalizations.of(context).minute}');
    }
  }
}
