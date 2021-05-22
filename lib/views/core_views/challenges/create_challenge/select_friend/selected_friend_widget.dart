import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/select_friend_screen.dart';
import 'package:flutter/material.dart';

typedef OnSelectedFriendChanged = void Function(Friend newSelectedFriend);

class SelectedFriendWidget extends StatefulWidget {
  final Friend passedSelectedFriend;
  final OnSelectedFriendChanged onSelectedFriendChanged;

  SelectedFriendWidget(
      {this.passedSelectedFriend, this.onSelectedFriendChanged});

  @override
  _SelectedFriendWidgetState createState() => _SelectedFriendWidgetState();
}

class _SelectedFriendWidgetState extends State<SelectedFriendWidget> {
  Friend _selectedFriend;

  @override
  void initState() {
    super.initState();
    _selectedFriend = widget.passedSelectedFriend;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              ),
              getSelectedFriendNameConditionally(),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) => 10),
                  shape: MaterialStateProperty.resolveWith((_) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
              onPressed: () async {
                Friendship friendship;
                try {
                  friendship = await ServiceProvider.usersService.getFriends();
                } on ApiException catch (e) {
                  SnackBarUtils.showSnackBar(
                    context,
                    e.error,
                  );
                  return;
                }
                Friend selectedFriend = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectFriendScreen(
                              friendship: friendship,
                            ))) as Friend;
                if (selectedFriend != null) {
                  setState(() {
                    _selectedFriend = selectedFriend;
                    widget.onSelectedFriendChanged(selectedFriend);
                  });
                }
              },
              child: getSelectFriendTextConditionally(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSelectedFriendNameConditionally() {
    String text = _selectedFriend == null
        ? AppLocalizations.of(context).noFriendSelected
        : '${AppLocalizations.of(context).youWillChallenge}: ${_selectedFriend.firstName} ${_selectedFriend.lastName}';
    Color color = _selectedFriend == null ? Colors.pink : Colors.black;
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color),
    );
  }

  getSelectFriendTextConditionally() {
    final String text = _selectedFriend == null
        ? AppLocalizations.of(context).selectAFriend
        : AppLocalizations.of(context).changeSelectedFriend;
    return Text(
      text,
      style: Theme.of(context).textTheme.button,
    );
  }
}
