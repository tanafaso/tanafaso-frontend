import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Holds all widgets keys.
class Keys {
  // Keys for widgets used in auth_main_screen.dart
  static const Key AUTH_MAIN_SCREEN_SIGN_UP_TEXT =
      Key('Auth main screen sign up text');
  static const Key AUTH_MAIN_SCREEN_SIGN_UP_BUTTON =
      Key('Auth main screen sign up button');
  static const Key AUTH_MAIN_SCREEN_LOGIN_TEXT =
      Key('Auth main screen login text');
  static const Key AUTH_MAIN_SCREEN_LOGIN_BUTTON =
      Key('Auth main screen login button');
  static const Key AUTH_MAIN_SCREEN_FACEBOOK_TEXT =
      Key('Auth main screen facebook text');
  static const Key AUTH_MAIN_SCREEN_FACEBOOK_BUTTON =
      Key('Auth main screen facebook button');

  // Keys for widgets used in sign_up_main_screen.dart
  static const Key SIGN_UP_MAIN_SCREEN = Key('Sign up widget');

  // Keys for widgets used in login_screen.dart
  static final GlobalKey<ScaffoldState> LOGIN_SCREEN =
      GlobalKey<ScaffoldState>();
}
