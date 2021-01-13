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

  HomePage();

  @override
  _HomePageState createState() {
    _homePageState = _HomePageState();
    return _homePageState;
  }

  static void setAppBarTitle(String appBarTitle) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homePageState.setState(() {
        _homePageState.setAppBarTitle(appBarTitle);
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
    List<Topic> topics = getTopics(context);
    return FutureBuilder(
      future: getUserToken(),
      builder: (context, AsyncSnapshot snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: Text(_app_bar_title),
            ),
            body: Center(
              child: topics[_selectedIdx].widget,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              items: topics.map((e) => e.bottomNavigationBarItem).toList(),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black,
              showUnselectedLabels: true,
              currentIndex: _selectedIdx,
              onTap: _onItemTapped,
            ));
      },
    );
  }

  List<Topic> getTopics(BuildContext context) {
    return [
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
              label: 'Challenges',
              backgroundColor: Theme.of(context).primaryColor),
          widget: ChallengesWidget()),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          widget: GroupsWidget()),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Friends',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          widget: FriendsWidget()),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          widget: ProfileWidget()),
    ];
  }
}
