// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:ui';

import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/landing_widget.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterRingtonePlayer.playNotification();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await rootBundle.load('assets/servercert.crt');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  FlutterStatusbarcolor.setStatusBarColor(Color(0xffcef5ce));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xffcef5ce),
    statusBarColor: Color(0xffcef5ce),
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _landingWidget;

  Future<FirebaseApp> asyncInitialization(BuildContext context) async {
    FirebaseApp app = await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return app;
  }

  @override
  void initState() {
    super.initState();

    ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncInitialization(context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_landingWidget == null) {
              _landingWidget = getMaterialAppWithBody(LandingWidget());
            }
            return _landingWidget;
          } else if (snapshot.hasError) {
            print('حدث خطأ أثناء إعداد هذا الجهاز لتلقي الإخطارات');

            if (_landingWidget == null) {
              _landingWidget = getMaterialAppWithBody(LandingWidget());
            }
            return _landingWidget;
          } else {
            // TODO(omorsi): Show loader
            return getMaterialAppWithBody(Container(
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ));
          }
        });
  }

  Widget getMaterialAppWithBody(Widget body) {
    return FeatureDiscovery(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).title,
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ar', ''),
        ],
        home: Scaffold(
          body: body,
        ),
        theme: ThemeData(
          primaryColor: Color(0xffcef5ce),
          accentColor: Colors.white,
          scaffoldBackgroundColor: Color(0xffcef5ce),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.white),
          buttonColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((_) => Colors.white),
          )),
          cardTheme: CardTheme(elevation: 10),
          iconTheme: IconThemeData(color: Colors.black),
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
            button: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
