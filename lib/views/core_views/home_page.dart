import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/users/requests/set_notifications_token_request_body.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/challenges_main_screen.dart';
import 'package:azkar/views/core_views/friends/friends_main_screen.dart';
import 'package:azkar/views/core_views/live_support_screen.dart';
import 'package:azkar/views/core_views/profile/profile_main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Topic {
  BottomNavigationBarItem bottomNavigationBarItem;
  TopicType topicType;

  Topic({@required this.bottomNavigationBarItem, @required this.topicType});
}

enum TopicType {
  CHALLENGES,
  FRIENDS,
  PROFILE,
  LIVE_SUPPORT,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String userToken;
  int _selectedIdx = 1;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
      });
    }
  }

  Future<void> getUserToken() async {
    userToken = await FlutterSecureStorage().read(key: 'jwtToken');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
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

  initFirebase() async {
    // Get the token each time the application loads.
    String token = await FirebaseMessaging.instance.getToken();

    // Send initial token to database.
    sendTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(sendTokenToDatabase);

    FirebaseMessaging.onMessage.listen(
        (_) => ServiceProvider.cacheManager.invalidateFrequentlyChangingData());
  }

  @override
  void initState() {
    super.initState();

    initFirebase();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    List<Topic> topics = getTopics(context);
    return FutureBuilder(
      future: getUserToken(),
      builder: (context, AsyncSnapshot snapshot) {
        return Scaffold(
            body: Center(
              child: getWidgetForTopicType(topics[_selectedIdx].topicType),
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
          topicType: TopicType.CHALLENGES),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: AppLocalizations.of(context).friends,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          topicType: TopicType.FRIENDS),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: AppLocalizations.of(context).profile,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          topicType: TopicType.PROFILE),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: "استفسار",
            backgroundColor: Theme.of(context).primaryColor,
          ),
          topicType: TopicType.LIVE_SUPPORT),
    ];
  }

  // ignore: missing_return
  Widget getWidgetForTopicType(TopicType topicType) {
    switch (topicType) {
      case TopicType.CHALLENGES:
        return ChallengesMainScreen();
      case TopicType.FRIENDS:
        return FriendsMainScreen();
      case TopicType.PROFILE:
        return ProfileMainScreen();
      case TopicType.LIVE_SUPPORT:
        return LiveSupportScreen();
    }
    assert(false);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }
}
