import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatefulWidget {
  final Friend friend;

  FriendRequestWidget({@required this.friend});

  @override
  _FriendRequestWidgetState createState() => _FriendRequestWidgetState();
}

enum FriendshipState { PENDING, ACCEPTED, REJECTED }

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  FriendshipState _friendshipState = FriendshipState.PENDING;

  @override
  Widget build(BuildContext context) {
    print(_friendshipState);
    switch (_friendshipState) {
      case FriendshipState.PENDING:
        return getPendingWidget();
      case FriendshipState.ACCEPTED:
        return getAcceptedWidget();
      case FriendshipState.REJECTED:
        return getRejectedWidget();
      default:
        assert(false);
        print('Unexpected friendship state.');
        return getAcceptedWidget();
    }
  }

  Widget getPendingWidget() {
    return Card(
      child: Row(
        children: [
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.friend.username}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: RaisedButton(
                    child: Text('Accept'),
                    color: Colors.green.shade400,
                    onPressed: () => setState(() {
                      _friendshipState = FriendshipState.ACCEPTED;
                    }),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: OutlineButton(
                    child: (Text('Ignore')),
                    onPressed: () => setState(() {
                      _friendshipState = FriendshipState.REJECTED;
                    }),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getAcceptedWidget() {
    return Card(
      child: Container(
        height: 20,
        child: Text(
          'Accepted',
          textAlign: TextAlign.center,
        ),
      ),
      color: Colors.green.shade400,
    );
  }

  Widget getRejectedWidget() {
    return Card(
      child: Container(
        height: 20,
        child: Text(
          'Rejected',
          textAlign: TextAlign.center,
        ),
      ),
      color: Colors.red.shade300,
    );
  }
}
