import 'package:azkar/models/friend.dart';
import 'package:flutter/material.dart';

typedef OnFriendSelectedChanged = Function(bool selected);

class FriendWidget extends StatefulWidget {
  final Friend friend;
  final OnFriendSelectedChanged onFriendSelectedChanged;

  FriendWidget({
    @required this.friend,
    @required this.onFriendSelectedChanged,
  });

  @override
  _FriendWidgetState createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget>
    with AutomaticKeepAliveClientMixin {
  bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selected = !_selected;
            widget.onFriendSelectedChanged(_selected);
          });
        },
        child: Card(
          color: _selected ? Colors.green.shade300 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                  VerticalDivider(
                    width: 3,
                    color: Colors.black,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.friend.firstName +
                                  " " +
                                  widget.friend.lastName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 8)),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.friend.username,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
