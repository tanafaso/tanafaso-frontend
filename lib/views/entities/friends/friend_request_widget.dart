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
            flex: 7,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('${widget.friend.username}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)],
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
                    onPressed: () => {},
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: OutlineButton(
                    child: (Text('Ignore')),
                    onPressed: () => {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
