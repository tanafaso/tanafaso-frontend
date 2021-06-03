import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/views/core_views/friends/all_friends/detailed_friend_list_item_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/summary_friend_list_item_widget.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

class FriendListItemWidget extends StatefulWidget {
  final FriendshipScores friendshipScores;
  final bool firstInList;

  FriendListItemWidget({
    @required this.friendshipScores,
    @required this.firstInList,
  });

  @override
  _FriendListItemWidgetState createState() => _FriendListItemWidgetState();
}

class _FriendListItemWidgetState extends State<FriendListItemWidget> {
  bool _detailedView;

  @override
  void initState() {
    super.initState();
    _detailedView = false;
  }

  @override
  Widget build(BuildContext context) {
    return !widget.firstInList
        ? getMainWidget()
        : DescribedFeatureOverlay(
            featureId: Features.FRIEND_DETAILED_VIEW,
            contentLocation: ContentLocation.below,
            tapTarget: Icon(Icons.done_outline),
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
                          AppLocalizations.of(context).detailedViewTitle,
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
                          AppLocalizations.of(context).detailedViewExplanation,
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
            targetColor: Theme.of(context).accentColor,
            textColor: Colors.black,
            overflowMode: OverflowMode.wrapBackground,
            child: getMainWidget());
  }

  Widget getMainWidget() {
    return _detailedView
        ? DetailedFriendListItemWidget(
            friendshipScores: widget.friendshipScores,
            toggleViewCallback: () {
              setState(() {
                _detailedView = false;
              });
            },
          )
        : SummaryFriendListItemWidget(
            friendshipScores: widget.friendshipScores,
            toggleViewCallback: () {
              setState(() {
                _detailedView = true;
              });
            },
          );
  }
}
