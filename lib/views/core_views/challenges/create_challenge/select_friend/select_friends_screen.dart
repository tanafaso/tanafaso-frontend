import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_friend/friend_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/how_to_add_friends_screen.dart';
import 'package:flutter/material.dart';

class SelectFriendsScreen extends StatefulWidget {
  final Friendship friendship;

  SelectFriendsScreen({@required this.friendship});

  @override
  _SelectFriendsScreenState createState() => _SelectFriendsScreenState();
}

class _SelectFriendsScreenState extends State<SelectFriendsScreen> {
  List<Friend> _selectedFriends;

  @override
  void initState() {
    super.initState();
    _selectedFriends = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectFriends),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    child: getFriendsList(
                        context,
                        widget.friendship?.friends
                                ?.where((friend) => !friend.pending)
                                ?.toList() ??
                            []))),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8, top: 8, bottom: 3 * 8.0),
              child: Container(
                child: ButtonTheme(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () => onCreatePressed(),
                    child: Center(
                        child: Text(
                      readyToFinish()
                          ? AppLocalizations.of(context).add
                          : AppLocalizations.of(context).addNotReady,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: readyToFinish() ? Colors.green.shade300 : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onCreatePressed() {
    if (!readyToFinish()) {
      if (!readyToFinish()) {
        SnackBarUtils.showSnackBar(
          context,
          AppLocalizations.of(context).pleaseChooseFriendsFirst,
        );
        return;
      }
    }

    Navigator.pop(context, _selectedFriends);
  }

  bool readyToFinish() => _selectedFriends.length != 0;

  Widget getFriendsList(BuildContext context, List<Friend> friends) {
    if (friends?.isEmpty ?? false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).noFriendsFound,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HowToAddFriendsScreen())),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).howToAddNewFriendsQuestion,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      padding: EdgeInsets.only(bottom: 8),
      itemBuilder: (context, index) {
        return FriendWidget(
          friend: friends[index],
          onFriendSelectedChanged: (bool selected) {
            setState(() {
              if (!selected) {
                _selectedFriends.removeWhere(
                    (friend) => friend.userId == friends[index].userId);
              } else {
                _selectedFriends.add(friends[index]);
              }
            });
          },
        );
      },
    );
  }
}
