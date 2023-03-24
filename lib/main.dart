// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:azkar/firebase_options.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/quran_utils.dart';
import 'package:azkar/views/landing_widget.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  ServiceProvider.cacheManager.invalidateFrequentlyChangingData();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData rootCert = await rootBundle.load('assets/gts-root-r1.crt');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(rootCert.buffer.asUint8List());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xffcef5ce),
    statusBarColor: Color(0xffcef5ce),
  ));
  if (QuranUtils.ayahs.isEmpty) {
    String quran = await rootBundle.loadString('assets/quran.txt');
    QuranUtils.ayahs = quran.split("\n");
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
      try {
        _firebaseApp = await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      } catch (e) {
        print(e);
      }
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: false,
          criticalAlert: true,
          provisional: true,
          sound: true,
        );
      }

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'challenges_and_friend_requests', // id
      'تحديات الاصدقاء وطلبات الصداقه', // title
      description:
          'اخطارات بخصوص تحديات الاصدقاء وطلبات الصداقه.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

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
            // ignore: deprecated_member_use
            primaryVariant: Color(0xffcee6ce),
            secondary: Colors.white,
            // ignore: deprecated_member_use
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
