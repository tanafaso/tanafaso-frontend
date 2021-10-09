import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/users/requests/set_notifications_token_request_body.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/challenges_main_screen.dart';
import 'package:azkar/views/core_views/friends/friends_main_screen.dart';
import 'package:azkar/views/core_views/live_support_screen.dart';
import 'package:azkar/views/core_views/profile/profile_main_screen.dart';
import 'package:azkar/views/core_views/settings/settings_main_screen.dart';
import 'package:clear_all_notifications/clear_all_notifications.dart';
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
  SETTINGS,
}

class HomePage extends StatefulWidget {
  final TopicType initiallySelectedTopicType;

  HomePage({this.initiallySelectedTopicType = TopicType.FRIENDS});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String userToken;
  int _selectedIdx;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ClearAllNotifications.clear();
      ServiceProvider.localNotificationsService
          .configureNextNudgeNotification();
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

    _selectedIdx = topicToIndex(widget.initiallySelectedTopicType);

    // Clears all active notifications.
    ClearAllNotifications.clear();
    initFirebase();
    ServiceProvider.localNotificationsService.configureNextNudgeNotification();

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
              backgroundColor: Theme.of(context).colorScheme.primary,
              items: topics.map((e) => e.bottomNavigationBarItem).toList(),
              selectedItemColor: Colors.green,
              type: BottomNavigationBarType.shifting,
              unselectedItemColor: Colors.black,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              currentIndex: _selectedIdx,
              onTap: _onItemTapped,
              unselectedFontSize: 18,
              selectedFontSize: 20,
              iconSize: 30,
              selectedIconTheme: IconThemeData(size: 35),
            ));
      },
    );
  }

  // ignore: missing_return
  int topicToIndex(TopicType topicType) {
    switch (topicType) {
      case TopicType.LIVE_SUPPORT:
        return 0;
      case TopicType.FRIENDS:
        return 1;
      case TopicType.CHALLENGES:
        return 2;
      case TopicType.PROFILE:
        return 3;
      case TopicType.SETTINGS:
        return 4;
    }
    assert(false);
  }

  List<Topic> getTopics(BuildContext context) {
    return [
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: "استفسار",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          topicType: TopicType.LIVE_SUPPORT),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            label: AppLocalizations.of(context).friends,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          topicType: TopicType.FRIENDS),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
              icon: Icon(Icons.whatshot_outlined),
              label: AppLocalizations.of(context).theChallenges,
              backgroundColor: Theme.of(context).colorScheme.primary),
          topicType: TopicType.CHALLENGES),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'الملف',
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          topicType: TopicType.PROFILE),
      Topic(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "الإعدادات",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          topicType: TopicType.SETTINGS),
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
      case TopicType.SETTINGS:
        return SettingsMainScreen();
    }
    assert(false);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }
}
