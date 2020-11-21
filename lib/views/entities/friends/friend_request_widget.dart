import 'package:azkar/models/friend.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:azkar/net/users_service.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatefulWidget {
  final Friend friend;
  final State parentState;

  FriendRequestWidget({@required this.friend, @required this.parentState});

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
                    onPressed: () => onAcceptedPressed(),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: OutlineButton(
                    child: (Text('Ignore')),
                    onPressed: () => onRejectedPressed(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onAcceptedPressed() async {
    ResolveFriendRequestResponse response =
        await UsersService.acceptFriend(widget.friend.userId);
    if (response.hasError()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade400,
        content: Text('${widget.friend.name} is now your friend.'),
      ));
      widget.parentState.setState(() {});
    }
  }

  void onRejectedPressed() async {
    ResolveFriendRequestResponse response =
        await UsersService.rejectFriend(widget.friend.userId);
    if (response.hasError()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("${widget.friend.name}'s friend request is ignored."),
      ));
      widget.parentState.setState(() {});
    }
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
