import 'package:azkar/models/friendship_scores.dart';
import 'package:flutter/material.dart';

typedef OnToggleViewCallback = void Function();

class SummaryFriendListItemWidget extends StatelessWidget {
  final FriendshipScores friendshipScores;
  final OnToggleViewCallback toggleViewCallback;

  SummaryFriendListItemWidget({
    @required this.friendshipScores,
    @required this.toggleViewCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4.0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height / 12),
        child: RawMaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          fillColor: Colors.white,
          onPressed: () {
            toggleViewCallback.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    '${friendshipScores.friend.firstName} ${friendshipScores.friend.lastName}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (friendshipScores.currentUserScore -
                                friendshipScores.friendScore)
                            .abs()
                            .toString(),
                        style: TextStyle(
                          color: getColor(),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 8)),
                      getArrowIcon(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Icon getArrowIcon() {
    if (friendshipScores.friendScore > friendshipScores.currentUserScore) {
      return Icon(
        Icons.arrow_downward,
        color: getColor(),
      );
    } else if (friendshipScores.friendScore <
        friendshipScores.currentUserScore) {
      return Icon(
        Icons.arrow_upward,
        color: getColor(),
      );
    }
    return Icon(
      Icons.done_all,
      color: getColor(),
    );
  }

  Color getColor() {
    if (friendshipScores.friendScore > friendshipScores.currentUserScore) {
      return Colors.red;
    } else if (friendshipScores.friendScore <
        friendshipScores.currentUserScore) {
      return Colors.green;
    }
    return Colors.yellow.shade700;
  }
}
