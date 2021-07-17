import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:crisp/crisp.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class LiveSupportScreen extends StatefulWidget {
  @override
  _LiveSupportScreenState createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<LiveSupportScreen>
    with SingleTickerProviderStateMixin {
  CrispMain crispMain;

  String _userId;
  String _userFullName;
  AnimationController _loadingAnimationController;

  @override
  void initState() {
    super.initState();

    HomePage.setAppBarTitle('الاستفسارات والطلبات');

    _loadingAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _loadingAnimationController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _userId = await ServiceProvider.usersService.getCurrentUserId();
      _userFullName =
          await ServiceProvider.usersService.getCurrentUserFullName();

      crispMain = CrispMain(
        websiteId: '49ccee9e-e5a5-4319-bd8d-f5eb37df0f0b',
        userToken: sha512.convert(utf8.encode(_userId)).toString(),
      );

      crispMain.register(
        user: CrispUser(
          nickname: _userFullName,
          email: "hide_email@example.com",
        ),
      );

      crispMain.setSessionData({
        "app_version": ApiCaller.API_VERSION,
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return crispMain == null
        ? Center(
            child: RotationTransition(
              child: Image.asset('assets/images/logo.png'),
              turns: Tween(begin: 0.0, end: 1.0)
                  .animate(_loadingAnimationController),
            ),
          )
        : CrispView(
            appBar: AppBar(
              title: const Text('Widget WebView'),
            ),
            loadingWidget: Center(
              child: CircularProgressIndicator(),
            ),
            crispMain: crispMain,
          );
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
  }
}
