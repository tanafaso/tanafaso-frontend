import 'package:auto_size_text/auto_size_text.dart';
import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

typedef OnToggleViewCallback = void Function();

class SummaryFriendListItemWidget extends StatelessWidget {
  final Friend friendshipScore;
  final OnToggleViewCallback toggleViewCallback;

  SummaryFriendListItemWidget({
    @required this.friendshipScore,
    @required this.toggleViewCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4.0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height / 10),
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
                  child: AutoSizeText(
                    '${friendshipScore.firstName} ${friendshipScore.lastName}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        (friendshipScore.userTotalScore -
                                friendshipScore.friendTotalScore)
                            .abs()
                            .toString(),
                        style: TextStyle(color: getColor(), fontSize: 25),
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
    if (friendshipScore.friendTotalScore > friendshipScore.userTotalScore) {
      return Icon(
        Icons.arrow_downward,
        color: getColor(),
      );
    } else if (friendshipScore.friendTotalScore <
        friendshipScore.userTotalScore) {
      return Icon(
        Icons.arrow_upward,
        color: getColor(),
      );
    }
    return Icon(
      Icons.done_all,
      size: 25,
      color: getColor(),
    );
  }

  Color getColor() {
    if (friendshipScore.friendTotalScore > friendshipScore.userTotalScore) {
      return Colors.red;
    } else if (friendshipScore.friendTotalScore <
        friendshipScore.userTotalScore) {
      return Colors.green;
    }
    return Colors.yellow.shade700;
  }
}
