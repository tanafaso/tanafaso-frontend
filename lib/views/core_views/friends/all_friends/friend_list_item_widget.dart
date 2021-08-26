import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/views/core_views/friends/all_friends/detailed_friend_list_item_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/summary_friend_list_item_widget.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

class FriendListItemWidget extends StatefulWidget {
  final FriendshipScores friendshipScores;

  FriendListItemWidget({
    @required this.friendshipScores,
  });

  @override
  _FriendListItemWidgetState createState() => _FriendListItemWidgetState();
}

class _FriendListItemWidgetState extends State<FriendListItemWidget> {
  bool _detailedView;
  bool _isSabeq;

  @override
  void initState() {
    super.initState();

    _isSabeq = false;
    _detailedView = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        if (mounted) {
          String sabeqId = await ServiceProvider.usersService.getSabeqId();
          setState(() {
            _isSabeq = sabeqId == widget.friendshipScores.friend.userId;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isSabeq
        ? getMainWidget()
        : DescribedFeatureOverlay(
            featureId: Features.SABEQ_INTRODUCTION,
            overflowMode: OverflowMode.wrapBackground,
            barrierDismissible: false,
            backgroundDismissible: false,
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
                          AppLocalizations.of(context)
                              .sabeqAndDetailedViewTitle,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                          child: RichText(
                            text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: 'سابق',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold)),
                                new TextSpan(
                                    text:
                                        ' هو صديق افتراضي لك على التطبيق. اضغط على سابق لتتمكن من تحديه ولرؤية المزيد من المعلومات حول صداقتكم.'),
                              ],
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            targetColor: Theme.of(context).accentColor,
            textColor: Colors.black,
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
