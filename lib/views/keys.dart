import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Holds all widgets keys.
class Keys {
  // Keys for widgets used in auth_main_screen.dart
  static final GlobalKey authMainScreenSignUpText = new GlobalKey();
  static final GlobalKey authMainScreenSignUpButton = new GlobalKey();
  static final GlobalKey authMainScreenLoginText = new GlobalKey();
  static final GlobalKey authMainScreenLoginButton = new GlobalKey();
  static final GlobalKey authMainScreenFacebookText = new GlobalKey();
  static final GlobalKey authMainScreenFacebookButton = new GlobalKey();

  // Keys for widgets used in sign_up_main_screen.dart
  static final GlobalKey signUpMainScreen = new GlobalKey();

  // Keys for widgets used in login_screen.dart
  static final GlobalKey<ScaffoldState> loginScreen =
      GlobalKey<ScaffoldState>();

  // Keys for widgets used in all_friends_widget.dart
  static final GlobalKey allFriendsWidgetList = new GlobalKey();

  // Keys for widgets used in groups_main_screen_test.dart
  static final GlobalKey groupsMainScreenTabBar = new GlobalKey();
  static final GlobalKey groupsMainScreenAllGroupsTabKey = new GlobalKey();
  static final GlobalKey groupsMainScreenGroupInvitationsTabKey =
      new GlobalKey();
  static final GlobalKey groupsMainScreenFloatingButton = new GlobalKey();
}
