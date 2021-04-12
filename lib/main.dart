// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'title': 'تنافسوا',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور (باللغة الإنجليزية)',
      'forgot password': 'هل نسيت كلمة السر؟',
      'or login with': 'أو تسجيل الدخول باستخدام',
      'login': 'تسجيل الدخول',
      'sign up': 'اشتراك',
      'facebook': 'الفيسبوك',
      'password hint text': '********',
      'Password should be of at least 8 characters':
          'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
      'name': 'الاسم',
      'confirm password': 'تأكيد كلمة المرور',
      'already have an account': 'هل لديك حساب؟',
      'passwords did not match': 'كلمات المرور غير متطابقة',
      'email is invalid': 'البريد الإلكتروني غير صالح',
      'name example': 'مثال على الاسم',
      'name should be of at least 2 letters':
          'يجب أن يتكون الاسم من حرفين على الأقل',
      'ok': 'حسنا',
      'error': 'خطأ',
      'email verification': 'تأكيد بواسطة البريد الالكتروني',
      'enter the code sent to': 'أدخل الرمز المرسل إلى',
      'verification Successful': 'تم التحقق بنجاح',
      'email verified successfully': 'تم التحقق من البريد الإلكتروني بنجاح',
      'clear': 'مسح',
      'verify': 'تحقق',
      'resend': 'إعادة إرسال',
      'did not receive the code?': 'لم يصلك الرمز؟',
      'please fill up all the cells properly':
          'يرجى ملء جميع الخلايا بشكل صحيح',
      'challenges': 'التحديات',
      'friends': 'الأصدقاء',
      'profile': 'الملف الشخصي',
      'home page': 'الصفحة الرئيسية',
      'username': 'كود المستخدم',
      'loading': 'جار التحميل',
      'friend requests': 'طلبات صداقة',
      'add friend': 'أضف صديق',
      'loading friends': 'تحميل الأصدقاء',
      'is now your friend': 'الان صديقك',
      'friend request': 'طلب صداقة',
      'is ignored': 'تم تجاهله',
      'ignore': 'تجاهل',
      'accept': 'قبول',
      'no friends found': 'لم يتم العثور على أصدقاء',
      'invited': 'مدعو',
      'invite': 'ادع',
      'invite facebook Friends': 'دعوة أصدقاء الفيسبوك',
      'an invitation has been sent to': 'تم إرسال دعوة إلى',
      'connected facebook Successfully': 'تم ربط الفيسبوك بنجاح',
      'sent': 'تم ارساله',
      'failed': 'فشلت المحاولة',
      'sending': 'يتم إرسالها',
      'add facebook friend': 'إضافة صديق الفيسبوك',
      'connect your account with facebook': 'ربط حسابك بالفيسبوك',
      'or add friends by': 'أو أضف أصدقاء عن طريق',
      'username should have no spaces': 'يجب ألا يحتوي كود المستخدم على مسافات',
      'enter a username': 'أدخل كود المستخدم',
      'invite friends': 'ادعو أصدقاء',
      'no friend requests found': 'لم يتم العثور على طلبات صداقة',
      'create a challenge': 'أضف تحدي',
      'all challenges': 'كل التحديات',
      'personal challenges': 'التحديات الشخصية',
      'no personal challenges found': 'لم يتم العثور على تحديات شخصية',
      'loading the challenges': 'تحميل التحديات',
      'ends after': 'ينتهي بعد',
      'hours': 'ساعات',
      'hour': 'ساعة',
      'minutes': 'دقائق',
      'minute': 'دقيقة',
      'ends after less than': 'ينتهي بعد أقل من',
      'passed': 'انقضى',
      'deadline': 'الموعد الأخير',
      'motivation': 'تحفيز',
      'no challenges found': 'لا توجد تحديات',
      'name not found': 'لم يتم العثور على الاسم',
      'the friend': 'الصديق',
      'the group': 'المجموعة',
      'select zekr': 'اختر ذِكر',
      'add zekr': 'أضف ذِكر',
      'select a friend': 'اختر صديقًا',
      'you have not added any friends yet': 'لم تقم بإضافة أي أصدقاء بعد',
      'repetitions': 'التكرار',
      'no azkar selected': 'لم يتم اختيار أذكار',
      'the selected azkar': 'الأذكار المختارة',
      'change selected friend': 'تغيير الصديق المختار',
      'you will challenge': 'سوف تتحدى',
      'no friend selected': 'لم يتم اختيار أي صديق',
      'challenge has been added successfully': 'تمت إضافة التحدي بنجاح',
      'add': 'إضافة',
      'add (not ready)': 'إضافة (غير جاهز)',
      'days': 'أيام',
      'day': 'يوم',
      'challenge expires after': 'التحدي ينتهي بعد',
      'challenge name': 'اسم التحدي',
      'challenge a friend': 'أتحدى صديق',
      'challenge myself': 'أتحدى نفسي',
      'i want to': 'أريد أن',
      'days must be less than or equal 100':
          'يجب أن تكون الأيام أقل من أو تساوي 100',
      'days must be more than 0': 'يجب أن تكون الأيام أكثر من 0',
      'days must be a number from 1 to 100':
          'يجب أن تكون الأيام عبارة عن رقم من 1 إلى 100',
      'repetitions must be less than or equal 100':
          'يجب أن تكون التكرارات أقل من 100 أو تساويها',
      'repetitions must be more than 0': 'يجب أن يكون التكرار أكثر من 0',
      'repetitions must be a number from 1 to 100':
          'يجب أن يكون عدد التكرار من 1 إلى 100',
      'motivation should not be empty': 'لا ينبغي أن يكون الدافع فارغًا',
      'name should not be empty': 'يجب ألا يكون الاسم فارغًا',
      'click on zekr after reading it': 'اضغط على الذكر بعد قراءته',
      'you have finished reading it': 'لقد انتهيت من قراءته',
      'the remaining repetitions': 'التكرارات المتبقية',
      'you have finished the challenge successfully': 'لقد أنهيت التحدي بنجاح',
      'first name': 'الاسم الأول',
      'last name': 'اسم العائلة',
      'first name example': 'مثال على الاسم الأول',
      'last name example': 'مثال على اسم العائلة',
      'then': 'ثم',
    },
  };

  String get then {
    return _localizedValues[locale.languageCode]['then'];
  }

  String get firstNameExample {
    return _localizedValues[locale.languageCode]['first name example'];
  }

  String get lastNameExample {
    return _localizedValues[locale.languageCode]['last name example'];
  }

  String get firstName {
    return _localizedValues[locale.languageCode]['first name'];
  }

  String get lastName {
    return _localizedValues[locale.languageCode]['last name'];
  }

  String get day {
    return _localizedValues[locale.languageCode]['day'];
  }

  String get hour {
    return _localizedValues[locale.languageCode]['hour'];
  }

  String get minute {
    return _localizedValues[locale.languageCode]['minute'];
  }

  String get youHaveFinishedTheChallengeSuccessfully {
    return _localizedValues[locale.languageCode]
        ['you have finished the challenge successfully'];
  }

  String get theRemainingRepetitions {
    return _localizedValues[locale.languageCode]['the remaining repetitions'];
  }

  String get youHaveFinishedReadingIt {
    return _localizedValues[locale.languageCode]
        ['you have finished reading it'];
  }

  String get clickOnZekrAfterReadingIt {
    return _localizedValues[locale.languageCode]
        ['click on zekr after reading it'];
  }

  String get repetitions {
    return _localizedValues[locale.languageCode]['repetitions'];
  }

  String get challengeMyself {
    return _localizedValues[locale.languageCode]['challenge myself'];
  }

  String get addZekr {
    return _localizedValues[locale.languageCode]['add zekr'];
  }

  String get noAzkarSelected {
    return _localizedValues[locale.languageCode]['no azkar selected'];
  }

  String get theSelectedAzkar {
    return _localizedValues[locale.languageCode]['the selected azkar'];
  }

  String get changeSelectedFriend {
    return _localizedValues[locale.languageCode]['change selected friend'];
  }

  String get youWillChallenge {
    return _localizedValues[locale.languageCode]['you will challenge'];
  }

  String get noFriendSelected {
    return _localizedValues[locale.languageCode]['no friend selected'];
  }

  String get challengeHasBeenAddedSuccessfully {
    return _localizedValues[locale.languageCode]
        ['challenge has been added successfully'];
  }

  String get add {
    return _localizedValues[locale.languageCode]['add'];
  }

  String get addNotReady {
    return _localizedValues[locale.languageCode]['add (not ready)'];
  }

  String get days {
    return _localizedValues[locale.languageCode]['days'];
  }

  String get challengeExpiresAfter {
    return _localizedValues[locale.languageCode]['challenge expires after'];
  }

  String get challengeName {
    return _localizedValues[locale.languageCode]['challenge name'];
  }

  String get challengeAFriend {
    return _localizedValues[locale.languageCode]['challenge a friend'];
  }

  String get iWantTo {
    return _localizedValues[locale.languageCode]['i want to'];
  }

  String get selectAFriend {
    return _localizedValues[locale.languageCode]['select a friend'];
  }

  String get daysMustBeLessThanOrEqual100 {
    return _localizedValues[locale.languageCode]
        ['days must be less than or equal 100'];
  }

  String get daysMustBeMoreThan0 {
    return _localizedValues[locale.languageCode]['days must be more than 0'];
  }

  String get daysMustBeANumberFrom1to100 {
    return _localizedValues[locale.languageCode]
        ['days must be a number from 1 to 100'];
  }

  String get repetitionsMustBeLessThanOrEqual100 {
    return _localizedValues[locale.languageCode]
        ['repetitions must be less than or equal 100'];
  }

  String get repetitionsMustBeMoreThan0 {
    return _localizedValues[locale.languageCode]
        ['repetitions must be more than 0'];
  }

  String get repetitionsMustBeANumberFrom1to100 {
    return _localizedValues[locale.languageCode]
        ['repetitions must be a number from 1 to 100'];
  }

  String get youHaveNotAddedAnyFriendsYet {
    return _localizedValues[locale.languageCode]
        ['you have not added any friends yet'];
  }

  String get motivationShouldNotBeEmpty {
    return _localizedValues[locale.languageCode]
        ['motivation should not be empty'];
  }

  String get nameShouldNotBeEmpty {
    return _localizedValues[locale.languageCode]['name should not be empty'];
  }

  String get selectZekr {
    return _localizedValues[locale.languageCode]['select zekr'];
  }

  String get nameNotFound {
    return _localizedValues[locale.languageCode]['name not found'];
  }

  String get theFriend {
    return _localizedValues[locale.languageCode]['the friend'];
  }

  String get theGroup {
    return _localizedValues[locale.languageCode]['the group'];
  }

  String get motivation {
    return _localizedValues[locale.languageCode]['motivation'];
  }

  String get noChallengesFound {
    return _localizedValues[locale.languageCode]['no challenges found'];
  }

  String get endsAfter {
    return _localizedValues[locale.languageCode]['ends after'];
  }

  String get hours {
    return _localizedValues[locale.languageCode]['hours'];
  }

  String get minutes {
    return _localizedValues[locale.languageCode]['minutes'];
  }

  String get endsAfterLessThan {
    return _localizedValues[locale.languageCode]['ends after less than'];
  }

  String get passed {
    return _localizedValues[locale.languageCode]['passed'];
  }

  String get deadline {
    return _localizedValues[locale.languageCode]['deadline'];
  }

  String get noPersonalChallengesFound {
    return _localizedValues[locale.languageCode]
        ['no personal challenges found'];
  }

  String get createAChallenge {
    return _localizedValues[locale.languageCode]['create a challenge'];
  }

  String get loadingTheChallenges {
    return _localizedValues[locale.languageCode]['loading the challenges'];
  }

  String get allChallenges {
    return _localizedValues[locale.languageCode]['all challenges'];
  }

  String get personalChallenges {
    return _localizedValues[locale.languageCode]['personal challenges'];
  }

  String get noFriendRequestsFound {
    return _localizedValues[locale.languageCode]['no friend requests found'];
  }

  String get inviteFriends {
    return _localizedValues[locale.languageCode]['invite friends'];
  }

  String get connectedFacebookSuccessfully {
    return _localizedValues[locale.languageCode]
        ['connected facebook Successfully'];
  }

  String get sent {
    return _localizedValues[locale.languageCode]['sent'];
  }

  String get failed {
    return _localizedValues[locale.languageCode]['failed'];
  }

  String get sending {
    return _localizedValues[locale.languageCode]['sending'];
  }

  String get addFacebookFriend {
    return _localizedValues[locale.languageCode]['add facebook friend'];
  }

  String get connectYourAccountWithFacebook {
    return _localizedValues[locale.languageCode]
        ['connect your account with facebook'];
  }

  String get inviteFacebookFriends {
    return _localizedValues[locale.languageCode]['invite facebook Friends'];
  }

  String get orAddFriendsBy {
    return _localizedValues[locale.languageCode]['or add friends by'];
  }

  String get usernameShouldHaveNoSpaces {
    return _localizedValues[locale.languageCode]
        ['username should have no spaces'];
  }

  String get enterAUsername {
    return _localizedValues[locale.languageCode]['enter a username'];
  }

  String get invited {
    return _localizedValues[locale.languageCode]['invited'];
  }

  String get invite {
    return _localizedValues[locale.languageCode]['invite'];
  }

  String get anInvitationHasBeenSentTo {
    return _localizedValues[locale.languageCode]
        ['an invitation has been sent to'];
  }

  String get noFriendsFound {
    return _localizedValues[locale.languageCode]['no friends found'];
  }

  String get ignore {
    return _localizedValues[locale.languageCode]['ignore'];
  }

  String get accept {
    return _localizedValues[locale.languageCode]['accept'];
  }

  String get isNowYourFriend {
    return _localizedValues[locale.languageCode]['is now your friend'];
  }

  String get friendRequest {
    return _localizedValues[locale.languageCode]['friend request'];
  }

  String get isIgnored {
    return _localizedValues[locale.languageCode]['is ignored'];
  }

  String get loadingFriends {
    return _localizedValues[locale.languageCode]['loading friends'];
  }

  String get addFriend {
    return _localizedValues[locale.languageCode]['add friend'];
  }

  String get friendRequests {
    return _localizedValues[locale.languageCode]['friend requests'];
  }

  String get loading {
    return _localizedValues[locale.languageCode]['loading'];
  }

  String get username {
    return _localizedValues[locale.languageCode]['username'];
  }

  String get challenges {
    return _localizedValues[locale.languageCode]['challenges'];
  }

  String get homePage {
    return _localizedValues[locale.languageCode]['home page'];
  }

  String get friends {
    return _localizedValues[locale.languageCode]['friends'];
  }

  String get profile {
    return _localizedValues[locale.languageCode]['profile'];
  }

  String get enterTheCodeSentTo {
    return _localizedValues[locale.languageCode]['enter the code sent to'];
  }

  String get clear {
    return _localizedValues[locale.languageCode]['clear'];
  }

  String get resend {
    return _localizedValues[locale.languageCode]['resend'];
  }

  String get didNotReceiveTheCjode {
    return _localizedValues[locale.languageCode]['did not receive the code'];
  }

  String get pleaseFillUpAllTheCellsProperly {
    return _localizedValues[locale.languageCode]
        ['please fill up all the cells properly'];
  }

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get email {
    return _localizedValues[locale.languageCode]['email'];
  }

  String get password {
    return _localizedValues[locale.languageCode]['password'];
  }

  String get forgotPassword {
    return _localizedValues[locale.languageCode]['forgot password'];
  }

  String get orLoginWith {
    return _localizedValues[locale.languageCode]['or login with'];
  }

  String get login {
    return _localizedValues[locale.languageCode]['login'];
  }

  String get signUp {
    return _localizedValues[locale.languageCode]['sign up'];
  }

  String get facebook {
    return _localizedValues[locale.languageCode]['facebook'];
  }

  String get passwordHintText {
    return _localizedValues[locale.languageCode]['password hint text'];
  }

  String get passwordShouldBeOfAtLeast8Characters {
    return _localizedValues[locale.languageCode]
        ['Password should be of at least 8 characters'];
  }

  String get name {
    return _localizedValues[locale.languageCode]['name'];
  }

  String get confirmPassword {
    return _localizedValues[locale.languageCode]['confirm password'];
  }

  String get alreadyHaveAnAccount {
    return _localizedValues[locale.languageCode]['already have an account'];
  }

  String get passwordsDidNotMatch {
    return _localizedValues[locale.languageCode]['passwords did not match'];
  }

  String get emailIsInvalid {
    return _localizedValues[locale.languageCode]['email is invalid'];
  }

  String get nameExample {
    return _localizedValues[locale.languageCode]['name example'];
  }

  String get nameShouldBeOfAtLeast2Letters {
    return _localizedValues[locale.languageCode]
        ['name should be of at least 2 letters'];
  }

  String get ok {
    return _localizedValues[locale.languageCode]['ok'];
  }

  String get error {
    return _localizedValues[locale.languageCode]['error'];
  }

  String get emailVerification {
    return _localizedValues[locale.languageCode]['email verification'];
  }

  String get verify {
    return _localizedValues[locale.languageCode]['verify'];
  }

  String get verificationSuccessful {
    return _localizedValues[locale.languageCode]['verification Successful'];
  }

  String get emailVerifiedSuccessfully {
    return _localizedValues[locale.languageCode]['email verified successfully'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ar', ''),
      ],
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
    );
  }
}
