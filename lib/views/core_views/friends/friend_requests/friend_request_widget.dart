import 'package:azkar/main.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatefulWidget {
  final Friend friend;
  final State parentState;

  FriendRequestWidget({@required this.friend, @required this.parentState});

  @override
  _FriendRequestWidgetState createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  @override
  Widget build(BuildContext context) {
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
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child: Text(AppLocalizations.of(context).accept),
                    color: Colors.green.shade400,
                    onPressed: () => onAcceptedPressed(),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  // ignore: deprecated_member_use
                  child: OutlineButton(
                    child: (Text(AppLocalizations.of(context).ignore)),
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
        await ServiceProvider.usersService.acceptFriend(widget.friend.userId);
    if (response.hasError()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade400,
        content: Text(
            '${widget.friend.name} ${AppLocalizations.of(context).isNowYourFriend}'),
      ));
      widget.parentState.setState(() {});
    }
  }

  void onRejectedPressed() async {
    ResolveFriendRequestResponse response =
        await ServiceProvider.usersService.rejectFriend(widget.friend.userId);
    if (response.hasError()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "${AppLocalizations.of(context).friendRequest} ${widget.friend.name} ${AppLocalizations.of(context).isIgnored}"),
      ));
      widget.parentState.setState(() {});
    }
  }
}
