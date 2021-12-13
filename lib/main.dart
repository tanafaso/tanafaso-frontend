// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:ui';

import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/quran_ayahs.dart';
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
  if (QuranAyahs.ayahs.isEmpty) {
    String quran = await rootBundle.loadString('assets/quran.txt');
    QuranAyahs.ayahs = quran.split("\n");
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _landingWidget;
  String _azkarAndQuranFontFamily;
  String _nonAzkarAndNonQuranFontFamily;
  FirebaseApp _firebaseApp;

  Future<void> asyncInitialization(BuildContext context) async {
    if (_firebaseApp == null) {
      _firebaseApp = await Firebase.initializeApp();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      if (Platform.isIOS) {
        FirebaseMessaging.instance.requestPermission();
      }
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }

    _azkarAndQuranFontFamily =
        await ServiceProvider.fontService.getPreferredAzkarAndQuranFontFamily();
    _nonAzkarAndNonQuranFontFamily = await ServiceProvider.fontService
        .getPreferredNonAzkarAndNonQuranFontFamily();
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
          primaryColor: Color(0xffcef6ce),
          colorScheme: ColorScheme(
            primary: Color(0xffcef5ce),
            primaryVariant: Color(0xffcee6ce),
            secondary: Colors.white,
            secondaryVariant: Colors.white30,
            surface: Colors.white,
            background: Color(0xffcef5ce),
            error: Colors.red.shade600,
            onPrimary: Color(0xffcef5ce),
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onBackground: Color(0xffcef5ce),
            onError: Colors.red.shade600,
            brightness: Brightness.light,
          ),
          buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
            primary: Colors.white,
          )),
          scaffoldBackgroundColor: Color(0xffcef5ce),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          cardTheme: CardTheme(elevation: 10),
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline1: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline2: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline3: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline4: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline5: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline6: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            subtitle1: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            subtitle2: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            bodyText1: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            bodyText2: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            button: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
          ),
          primaryTextTheme: TextTheme(
            headline1: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline2: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline3: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline4: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline5: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            headline6: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            subtitle1: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            subtitle2: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            bodyText1: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            bodyText2: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
            button: TextStyle(
                color: Colors.black,
                fontFamily: _nonAzkarAndNonQuranFontFamily),
          ),
          indicatorColor: Colors.white,
          tabBarTheme: TabBarTheme(
            labelColor: Color(0xffcef5ce),
          ),
          fontFamily: _nonAzkarAndNonQuranFontFamily,
          // That's a hack used to save a secondary font family only used
          // throughout the whole app for azkar and quran.
          // ignore: deprecated_member_use
          accentTextTheme: TextTheme(
              bodyText1: TextStyle(fontFamily: _azkarAndQuranFontFamily)),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xffcef5ce),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: _nonAzkarAndNonQuranFontFamily,
            ),
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
          ),
        ),
      ),
    );
  }
}
