import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/select_friends_screen.dart';
import 'package:flutter/material.dart';

typedef OnSelectedFriendsChanged = void Function(
    List<Friend> newSelectedFriends);

class SelectedFriendsWidget extends StatefulWidget {
  final List<Friend> initiallySelectedFriends;
  final OnSelectedFriendsChanged onSelectedFriendsChanged;

  SelectedFriendsWidget(
      {this.initiallySelectedFriends = const [],
      this.onSelectedFriendsChanged});

  @override
  _SelectedFriendsWidgetState createState() => _SelectedFriendsWidgetState();
}

class _SelectedFriendsWidgetState extends State<SelectedFriendsWidget> {
  List<Friend> _selectedFriends;

  @override
  void initState() {
    super.initState();

    _selectedFriends = widget.initiallySelectedFriends;
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
              getTitle(),
            ],
          ),
          Visibility(
            visible: (_selectedFriends?.length ?? 0) != 0,
            maintainSize: false,
            child: getSelectedFriends(),
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
                List<Friend> selectedFriends = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectFriendsScreen(
                      friendship: friendship,
                    ),
                  ),
                ) as List<Friend>;

                setState(() {
                  _selectedFriends =
                      selectedFriends == null ? [] : selectedFriends;
                  widget.onSelectedFriendsChanged(_selectedFriends);
                });
              },
              child: getSelectFriendText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitle() {
    String text;
    Color color;
    if ((_selectedFriends?.length ?? 0) == 0) {
      text = AppLocalizations.of(context).noFriendsSelected;
      color = Colors.pink;
    } else {
      text = AppLocalizations.of(context).selectedFriends;
      color = Colors.black;
    }
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color),
    );
  }

  Widget getSelectedFriends() {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.only(left: 8 * 3.0, right: 8),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 8),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            shrinkWrap: true,
            itemCount: _selectedFriends.length,
            itemBuilder: (context, index) {
              return Text(
                '${_selectedFriends[index].firstName} ${_selectedFriends[index].lastName}',
              );
            },
          ),
        ),
      ),
    );
  }

  getSelectFriendText() {
    final String text = (_selectedFriends?.length ?? 0) == 0
        ? AppLocalizations.of(context).selectFriends
        : AppLocalizations.of(context).changeSelectedFriends;
    return Text(
      text,
      style: Theme.of(context).textTheme.button,
    );
  }
}
