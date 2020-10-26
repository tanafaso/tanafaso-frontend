import 'package:azkar/views/entities/challenges/challenges_widget.dart';
import 'package:azkar/views/entities/friends/friends_widget.dart';
import 'package:azkar/views/entities/groups/groups_widget.dart';
import 'package:azkar/views/entities/profile/profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Topic {
  BottomNavigationBarItem bottomNavigationBarItem;
  Widget widget;

  Topic({@required this.bottomNavigationBarItem, @required this.widget});
}

class HomePage extends StatefulWidget {
  static _HomePageState _homePageState;
  final String _error_message;
  final List<Topic> _topics = [
    Topic(
        bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.whatshot), label: 'Challenges'),
        widget: ChallengesWidget()),
    Topic(
        bottomNavigationBarItem:
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
        widget: GroupsWidget()),
    Topic(
        bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.contacts), label: 'Friends'),
        widget: FriendsWidget()),
    Topic(
        bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: 'Profile'),
        widget: ProfileWidget()),
  ];

  HomePage(this._error_message);

  @override
  _HomePageState createState() {
    _homePageState = _HomePageState();
    return _homePageState;
  }

  static void setAppBarTitle(String app_bar_title) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homePageState.setState(() {
        _homePageState.setAppBarTitle(app_bar_title);
      });
    });
  }
}

class _HomePageState extends State<HomePage> {
  String userToken;
  int _selectedIdx = 0;
  String _app_bar_title = 'Home Page';

  Future<void> getUserToken() async {
    userToken = await FlutterSecureStorage().read(key: 'jwtToken');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  void setAppBarTitle(String app_bar_title) {
    _app_bar_title = app_bar_title;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserToken(),
      builder: (context, AsyncSnapshot snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: Text(_app_bar_title),
            ),
            body: Center(
              child: widget._topics[_selectedIdx].widget,
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              items:
                  widget._topics.map((e) => e.bottomNavigationBarItem).toList(),
              selectedItemColor: Colors.amber[800],
              currentIndex: _selectedIdx,
              onTap: _onItemTapped,
            ));
      },
    );
  }
}
