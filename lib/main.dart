// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:azkar/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'azkar',
        home: Scaffold(
          body: Center(
            child: FacebookSignInButton(onPressed: () {
              Authentication.loginWithFacebook();
            }),
          ),
        ));
  }
}
