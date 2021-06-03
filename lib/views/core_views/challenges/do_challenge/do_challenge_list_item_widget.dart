import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef SubChallengeChangedCallback = void Function(
    SubChallenge newSubChallenge);

class DoChallengeSubChallengeListItemWidget extends StatefulWidget {
  final SubChallenge subChallenge;
  final SubChallengeChangedCallback callback;
  final bool firstItemInList;

  // Only use to check if the challenge is expired, since other data may change
  // and will not be consistent.
  final Challenge challenge;

  DoChallengeSubChallengeListItemWidget({
    @required this.subChallenge,
    @required this.callback,
    @required this.challenge,
    @required this.firstItemInList,
  });

  @override
  _DoChallengeSubChallengeListItemWidgetState createState() =>
      _DoChallengeSubChallengeListItemWidgetState();
}

class _DoChallengeSubChallengeListItemWidgetState
    extends State<DoChallengeSubChallengeListItemWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Color buttonColor;
  int initialRepetitions;

  @override
  void initState() {
    super.initState();
    initialRepetitions = widget.subChallenge.repetitions;
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        // Feature ids for every feature that you want to showcase in order.
        [Features.CLICK_ZEKR_AFTER_FINISH],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Necessary as documented by AutomaticKeepAliveClientMixin.
    super.build(context);

    if (buttonColor == null) {
      buttonColor = widget.subChallenge.done()
          ? Theme.of(context).primaryColor
          : Theme.of(context).buttonColor;
    }

    return !widget.firstItemInList
        ? getMainWidget()
        : DescribedFeatureOverlay(
            featureId: Features.CLICK_ZEKR_AFTER_FINISH,
            contentLocation: ContentLocation.above,
            tapTarget: Icon(Icons.done),
            // The widget that will be displayed as the tap target.
            description: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          AppLocalizations.of(context).doingAChallenge,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Row(
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
                              .clickOnZekrAfterReadingIt,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            targetColor: Colors.white,
            textColor: Colors.black,
            child: getMainWidget(),
          );
  }

  Widget getMainWidget() {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.subChallenge.done()) {
          return;
        }
        if (widget.challenge.deadlinePassed()) {
          SnackBarUtils.showSnackBar(
            context,
            AppLocalizations.of(context)
                .theDeadlineHasAlreadyPassedForThisChallenge,
          );
          return;
        }
        setState(() {
          buttonColor = Theme.of(context).primaryColor;
          widget.subChallenge.repetitions -= 1;
          widget.callback.call(widget.subChallenge);
        });
      },
      onTapUp: (_) {
        if (widget.subChallenge.repetitions != 0) {
          setState(() {
            buttonColor = Theme.of(context).buttonColor;
          });
        }
      },
      child: Card(
        margin: EdgeInsets.all(0),
        color: buttonColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.subChallenge.zekr.zekr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getRepetitionsTextConditionally(),
            ),
            LinearProgressIndicator(
              minHeight: 10,
              // Reversed them. This is just a hack as I am afraid that
              // widget.subChallenge.repetitions maybe zero at some point.
              color: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              value: initialRepetitions == 0
                  ? 0
                  : widget.subChallenge.repetitions.toDouble() /
                      initialRepetitions.toDouble(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRepetitionsTextConditionally() {
    if (widget.subChallenge.repetitions == 0) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.done_outline),
          ),
          Text(
            AppLocalizations.of(context).youHaveFinishedReadingIt,
          ),
        ],
      );
    }

    return Text(
      '${AppLocalizations.of(context).theRemainingRepetitions}: ${ArabicUtils.englishToArabic(widget.subChallenge.repetitions.toString())}',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
