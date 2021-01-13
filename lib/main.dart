// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azkar',
      home: Scaffold(
        body: AuthMainScreen(),
      ),
      theme: ThemeData(
        primaryColor: Color(0xffcef5ce),
        accentColor: Color(0xffcef5ce),
        scaffoldBackgroundColor: Color(0xffcef5ce),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.white),
        buttonColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          headline3: TextStyle(color: Colors.black),
          headline4: TextStyle(color: Colors.black),
          headline5: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black),
          subtitle2: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
