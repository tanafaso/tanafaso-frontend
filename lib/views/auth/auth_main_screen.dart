import 'dart:io';

import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/auth/login/login_screen.dart';
import 'package:azkar/views/auth/signup/signup_main_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

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
        body: SingleChildScrollView(
      child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: new SingleChildScrollView(
                child: new Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: new Column(
                    children: <Widget>[
                      Flexible(
                          flex: Platform.isAndroid ? 4 : 7,
                          fit: FlexFit.tight,
                          child: Column(children: [
                            Expanded(
                                flex: 1,
                                child: Padding(padding: EdgeInsets.all(16))),
                            Expanded(
                              flex: 1,
                              child: new Row(
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
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: RotationTransition(
                                  child: Image.asset('assets/images/logo.png'),
                                  turns: Tween(begin: 0.0, end: 1.0)
                                      .animate(_controller),
                                ),
                              ),
                            ),
                          ])),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Column(children: [
                            Text(AppLocalizations.of(context).areYouANewUser,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                            Padding(padding: EdgeInsets.only(top: 8 * 3.0)),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          left: 4.0, right: 30.0),
                                      alignment: Alignment.center,
                                      child: new Column(
                                        children: <Widget>[
                                          new Expanded(
                                            // ignore: deprecated_member_use
                                            child: new FlatButton(
                                              key: Keys
                                                  .authMainScreenLoginButton,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SignUpMainScreen()));
                                              },
                                              child: new Container(
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .yes,
                                                        key: Keys
                                                            .authMainScreenSignUpText,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .green.shade900,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          left: 30.0, right: 4.0),
                                      alignment: Alignment.center,
                                      child: new Column(
                                        children: <Widget>[
                                          new Expanded(
                                            // ignore: deprecated_member_use
                                            child: new OutlineButton(
                                              key: Keys
                                                  .authMainScreenSignUpButton,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              highlightedBorderColor:
                                                  Colors.white,
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen())),
                                              child: new Container(
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .no,
                                                        key: Keys
                                                            .authMainScreenLoginText,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .green.shade900,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
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
                            Visibility(
                              visible: Platform.isAndroid,
                              child: Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Container(
                                          height: 1,
                                          margin: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 0.25)),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .orLoginWith,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          height: 1,
                                          margin: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 0.25)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: Platform.isAndroid,
                              child: Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Flexible(
                                        // ignore: deprecated_member_use
                                        child: new FlatButton(
                                          key:
                                              Keys.authMainScreenFacebookButton,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          color: Color(0Xff3B5998),
                                          onPressed: () => {},
                                          child: new Container(
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Flexible(
                                                  // ignore: deprecated_member_use
                                                  child: new FlatButton(
                                                    onPressed: () =>
                                                        loginWithFacebook(
                                                            context),
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Icon(
                                                          const IconData(0xea90,
                                                              fontFamily:
                                                                  'icomoon'),
                                                          color: Colors.white,
                                                          size: 20.0,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .facebook,
                                                            key: Keys
                                                                .authMainScreenFacebookText,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                  padding: EdgeInsets.only(
                                                    right: 20.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                            )
                          ]))
                    ],
                  ),
                ),
              ))),
    ));
  }

  loginWithFacebook(BuildContext context) async {
    try {
      await ServiceProvider.authenticationService.loginWithFacebook();
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
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
