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
            child: SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          Column(children: [
            Padding(padding: EdgeInsets.all(16)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Center(
              child: Image.asset(
                'assets/images/logo_fore.png',
                width: MediaQuery.of(context).size.width,
                height: Platform.isAndroid
                    ? MediaQuery.of(context).size.height * 2 / 5
                    : MediaQuery.of(context).size.height / 2,
              ),
            ),
          ]),
          Column(
            children: [
              Text(AppLocalizations.of(context).areYouANewUser,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(top: 8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 4.0, right: 30.0),
                    alignment: Alignment.center,
                    // ignore: deprecated_member_use
                    child: new FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpMainScreen()));
                      },
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
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 4.0),
                    alignment: Alignment.center,
                    child: new Column(
                      children: <Widget>[
                        // ignore: deprecated_member_use
                        new FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.white,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen())),
                          child: Text(
                            AppLocalizations.of(context).no,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8 * 2.0),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: SignInButton(
                            Buttons.Google,
                            shape: new RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(30.0)),
                            onPressed: () {
                              loginWithGoogle(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: SignInButton(
                            Buttons.Facebook,
                            shape: new RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(30.0)),
                            onPressed: () {
                              loginWithFacebook(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: Platform.isIOS,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: SignInButton(
                                Buttons.AppleDark,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                onPressed: () {
                                  loginWithApple(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              
              Padding(
                padding: EdgeInsets.all(16),
              )
            ],
          ),
        ],
      ),
    )));
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
