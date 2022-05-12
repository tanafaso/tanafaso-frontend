import 'dart:io';

import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/status.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/auth/login/login_screen.dart';
import 'package:azkar/views/auth/signup/signup_main_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMainScreen extends StatefulWidget {
  @override
  _AuthMainScreenState createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.repeat();
      bool isSignedIn =
          await ServiceProvider.secureStorageService.userSignedIn();
      if (isSignedIn) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()), (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SafeArea(
      child: new Column(
        children: <Widget>[
          Flexible(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(8)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Expanded(
                  child: FittedBox(
                    child: Icon(
                      Icons.directions_run,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 16)),
                Text(AppLocalizations.of(context).areYouANewUser,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 4.0, right: 30.0),
                      alignment: Alignment.center,
                      // ignore: deprecated_member_use
                      child: new RawMaterialButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        fillColor: Colors.white,
                        elevation: 2,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpMainScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context).yes,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Column(
                          children: <Widget>[
                            // ignore: deprecated_member_use
                            new RawMaterialButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              fillColor: Colors.white,
                              elevation: 2,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen())),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context).no,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: FittedBox(
                                  child: googleButton(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: FittedBox(
                                  child: facebookButton(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: Platform.isIOS,
                        child: Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: FittedBox(
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: SignInButton(
                                        Buttons.AppleDark,
                                        text: "Sign in with Apple",
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        onPressed: () {
                                          loginWithApple(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )));
  }

  Widget googleButton() {
    if (Platform.isIOS) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: SignInButton(
          Buttons.Google,
          text: "Sign in with Google",
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            loginWithGoogle(context);
          },
        ),
      );
    }
    return SignInButton(
      Buttons.Google,
      text: "جوجل",
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0)),
      onPressed: () {
        loginWithGoogle(context);
      },
    );
  }

  Widget facebookButton() {
    if (Platform.isIOS) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: SignInButton(
          Buttons.Facebook,
          text: "Sign in with Facebook",
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            loginWithFacebook(context);
          },
        ),
      );
    }
    return SignInButton(
      Buttons.Facebook,
      text: "الفيسبوك",
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0)),
      onPressed: () {
        loginWithFacebook(context);
      },
    );
  }

  loginWithFacebook(BuildContext context) async {
    try {
      await ServiceProvider.authenticationService.loginWithFacebook();
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.errorStatus.errorMessage);
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new HomePage()));
  }

  loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    String googleIdToken;
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      GoogleSignInAuthentication authentication = await account.authentication;
      googleIdToken = authentication.idToken;
    } catch (error) {
      print(error);
      return;
    }

    try {
      await ServiceProvider.authenticationService
          .loginWithGoogle(googleIdToken);
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.errorStatus.errorMessage);
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new HomePage()));
  }

  void loginWithApple(BuildContext context) async {
    try {
      await ServiceProvider.authenticationService.loginWithApple();
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.errorStatus.errorMessage);
      return;
    } on Exception catch (e) {
      print(e);
      SnackBarUtils.showSnackBar(context,
          new Status(Status.AUTHENTICATION_WITH_APPLE_ERROR).errorMessage);
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new HomePage()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
