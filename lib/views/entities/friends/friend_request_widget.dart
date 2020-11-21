import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatefulWidget {
  final Friend friend;

  FriendRequestWidget({@required this.friend});

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
            flex: 10,
            fit: FlexFit.tight,
            child: Column(
              children: [Text('Username: ${widget.friend.username}')],
            ),
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Row(
              children: [
                RaisedButton(
                  child: Text('Accept'),
                  color: Colors.green.shade400,
                  onPressed: () => {},
                ),
                OutlineButton(
                  child: (Text('Ignore')),
                  onPressed: () => {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
