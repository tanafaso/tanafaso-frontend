import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/payload/users/requests/set_notifications_token_request_body.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/challenges_main_screen.dart';
import 'package:azkar/views/core_views/friends/friends_main_screen.dart';
import 'package:azkar/views/core_views/profile/profile_main_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  final Widget challengesWidget = ChallengesMainScreen();
  final Widget friendsWidget = FriendsMainScreen();
  final Widget profileWidget = ProfileMainWidget();

  @override
  _HomePageState createState() {
    _homePageState = _HomePageState();
    return _homePageState;
  }

  static void setAppBarTitle(String appBarTitle) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: invalid_use_of_protected_member
      _homePageState.setState(() {
        _homePageState.setAppBarTitle(appBarTitle);
      });
    });
  }

  void selectNavigationBarItemForTesting(
      HomePageNavigationBarItem homePageNavigationBarItem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (homePageNavigationBarItem) {
        case HomePageNavigationBarItem.challenges:
          _homePageState._onItemTapped(0);
          break;
        case HomePageNavigationBarItem.friends:
          _homePageState._onItemTapped(1);
          break;
        case HomePageNavigationBarItem.profile:
          _homePageState._onItemTapped(2);
          break;
      }
    });
  }
}

enum HomePageNavigationBarItem { challenges, friends, profile }

class _HomePageState extends State<HomePage> {
  String userToken;
  int _selectedIdx = 1;
  String _appBarTitle = 'Home Page';

  Future<void> getUserToken() async {
    userToken = await FlutterSecureStorage().read(key: 'jwtToken');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  void setAppBarTitle(String appBarTitle) {
    _appBarTitle = appBarTitle;
  }

  void sendTokenToDatabase(String token) async {
    try {
      // Send the token to the server.
      await ServiceProvider.usersService.setNotificationsToken(
          SetNotificationsTokenRequestBody(token: token));
    } on ApiException catch (_) {
      SnackBarUtils.showSnackBar(
        context,
        AppLocalizations.of(context)
            .anErrorHappenedWhileSettingUpThisDeviceToReceiveNotifications,
      );

      return;
    }
  }

  getNotificationsToken() async {
    // Get the token each time the application loads.
    String token = await FirebaseMessaging.instance.getToken();

    // Send initial token to database.
    sendTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(sendTokenToDatabase);
  }

  @override
  void initState() {
    getNotificationsToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Topic> topics = getTopics(context);
    return FutureBuilder(
      future: getUserToken(),
      builder: (context, AsyncSnapshot snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: Text(_appBarTitle),
            ),
            body: Center(
              child: topics[_selectedIdx].widget,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              items: topics.map((e) => e.bottomNavigationBarItem).toList(),
              selectedItemColor: Colors.green,
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
              label: AppLocalizations.of(context).theChallenges,
              backgroundColor: Theme.of(context).primaryColor),
          widget: widget.challengesWidget),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: AppLocalizations.of(context).friends,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          widget: widget.friendsWidget),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: AppLocalizations.of(context).profile,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          widget: widget.profileWidget),
    ];
  }
}
