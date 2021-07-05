import 'package:azkar/models/friendship_scores.dart';
import 'package:flutter/material.dart';

// A widget that takes and old friendship score and adds one to the current user
// with animation to celebrate progress after finishing a challenge.
class AnimatedScoreChangeWidget extends StatefulWidget {
  final FriendshipScores friendshipScores;

  AnimatedScoreChangeWidget({@required this.friendshipScores});

  @override
  _AnimatedScoreChangeWidgetState createState() =>
      _AnimatedScoreChangeWidgetState();
}

class _AnimatedScoreChangeWidgetState extends State<AnimatedScoreChangeWidget>
    with AutomaticKeepAliveClientMixin {
  bool showOldScore;

  @override
  void initState() {
    super.initState();

    showOldScore = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widget.friendshipScores.currentUserScore++;
        showOldScore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              '${widget.friendshipScores.friend.firstName} ${widget.friendshipScores.friend.lastName}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: AnimatedSwitcher(
                    duration: Duration(seconds: 2),
                    child: showOldScore
                        ? Text(
                            (widget.friendshipScores.currentUserScore -
                                    widget.friendshipScores.friendScore)
                                .abs()
                                .toString(),
                            style: TextStyle(
                              color: getColor(),
                            ),
                            key: Key("1"),
                            softWrap: false,
                          )
                        : Text(
                            (widget.friendshipScores.currentUserScore -
                                    widget.friendshipScores.friendScore)
                                .abs()
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: getColor(),
                            ),
                            key: Key("2"),
                            softWrap: false,
                          ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 8)),
                AnimatedSwitcher(
                  child: showOldScore
                      ? getArrowIcon(Key("1"))
                      : getArrowIcon(Key("2")),
                  duration: Duration(seconds: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Icon getArrowIcon(Key key) {
    if (widget.friendshipScores.friendScore >
        widget.friendshipScores.currentUserScore) {
      return Icon(
        Icons.arrow_downward,
        key: key,
        color: getColor(),
      );
    } else if (widget.friendshipScores.friendScore <
        widget.friendshipScores.currentUserScore) {
      return Icon(
        Icons.arrow_upward,
        key: key,
        color: getColor(),
      );
    }
    return Icon(
      Icons.done_all,
      key: key,
      color: getColor(),
    );
  }

  Color getColor() {
    if (widget.friendshipScores.friendScore >
        widget.friendshipScores.currentUserScore) {
      return Colors.red;
    } else if (widget.friendshipScores.friendScore <
        widget.friendshipScores.currentUserScore) {
      return Colors.green;
    }
    return Colors.yellow.shade700;
  }

  @override
  bool get wantKeepAlive => true;
}
