import 'dart:io';

import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/authentication/requests/email_login_request_body.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/auth/login/reset_password_screen.dart';
import 'package:azkar/views/auth/signup/signup_main_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _passwordObscure = true;
  FocusNode passwordFocus;
  String _errorMessage;

  @override
  void initState() {
    super.initState();

    passwordFocus = new FocusNode();
    _errorMessage = "";
    _email = "";
    _password = "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: Keys.loginScreen,
        appBar: AppBar(title: Text(AppLocalizations.of(context).login)),
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: new SingleChildScrollView(
                    child: Form(
                  key: _loginFormKey,
                  child: new Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: SingleChildScrollView(
                      child: new Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 4 * 8.0)),
                          Column(
                            children: [
                              new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Padding(
                                      padding:
                                          const EdgeInsets.only(right: 40.0),
                                      child: new Text(
                                        AppLocalizations.of(context).email,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 10.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 0.0),
                                child: new Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      child: TextFormField(
                                        obscureText: false,
                                        autofocus: true,
                                        textAlign: TextAlign.left,
                                        onChanged: (email) => _email = email,
                                        onEditingComplete: () =>
                                            passwordFocus.requestFocus(),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'email@example.com',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 24.0,
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: new Text(
                                    AppLocalizations.of(context).password,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 10.0),
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            ),
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0.0),
                            child: new Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Expanded(
                                  child: TextFormField(
                                    obscureText: _passwordObscure,
                                    focusNode: passwordFocus,
                                    textAlign: TextAlign.left,
                                    onChanged: (password) =>
                                        _password = password,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: GestureDetector(
                                        onTap: () {
                                          setState(() => _passwordObscure =
                                              !_passwordObscure);
                                        },
                                        child: const Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.grey,
                                            )),
                                      ),
                                      hintText: AppLocalizations.of(context)
                                          .passwordHintText,
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 20.0,
                          ),
                          Visibility(
                            visible: _errorMessage.length > 0,
                            maintainSize: false,
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 20.0),
                            alignment: Alignment.center,
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                  // ignore: deprecated_member_use
                                  child: new FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      RegExp regex = new RegExp(
                                          '^[\\w-_\\.+]*[\\w-_\\.]\\@'
                                          '([\\w]+\\.)+[\\w]+[\\w]\$');
                                      if (regex.stringMatch(_email) != _email) {
                                        setState(() {
                                          _errorMessage =
                                              AppLocalizations.of(context)
                                                  .emailIsInvalid;
                                        });
                                        return;
                                      }
                                      if (_password.length < 8) {
                                        setState(() {
                                          _errorMessage = AppLocalizations.of(
                                                  context)
                                              .passwordShouldBeOfAtLeast8Characters;
                                        });
                                        return;
                                      }

                                      loginWithEmail(new EmailLoginRequestBody(
                                          email: _email, password: _password));
                                    },
                                    child: new Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 20.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Expanded(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .login,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
                          Visibility(
                            visible: Platform.isAndroid,
                            child: new Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 20.0),
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.25)),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).orLoginWith,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.25)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Platform.isAndroid,
                            child: new Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 20.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      alignment: Alignment.center,
                                      child: new Row(
                                        children: <Widget>[
                                          new Expanded(
                                            // ignore: deprecated_member_use
                                            child: new FlatButton(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              color: Color(0Xff3B5998),
                                              onPressed: () => {},
                                              child: new Container(
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Container(
                                                      padding: EdgeInsets.only(
                                                        left: 20.0,
                                                      ),
                                                    ),
                                                    new Expanded(
                                                      // ignore: deprecated_member_use
                                                      child: new FlatButton(
                                                        onPressed: () =>
                                                            loginWithFacebook(),
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 20.0,
                                                          bottom: 20.0,
                                                        ),
                                                        child: new Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .facebook,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Icon(
                                                              const IconData(
                                                                  0xea90,
                                                                  fontFamily:
                                                                      'icomoon'),
                                                              color:
                                                                  Colors.white,
                                                              size: 20.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    new Container(
                                                      padding: EdgeInsets.only(
                                                        left: 20.0,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // ignore: deprecated_member_use
                                new FlatButton(
                                  child: new Text(
                                    AppLocalizations.of(context)
                                        .youDoNotHaveAnAccount,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new SignUpMainScreen()));
                                  },
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.all(1),
                                )),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    // ignore: deprecated_member_use
                                    new FlatButton(
                                      child: new Text(
                                        AppLocalizations.of(context)
                                            .forgotPassword,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new ResetPasswordScreen()));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )))),
      ),
    );
  }

  loginWithFacebook() async {
    try {
      await ServiceProvider.authenticationService.loginWithFacebook();
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  loginWithEmail(EmailLoginRequestBody request) async {
    try {
      await ServiceProvider.authenticationService.login(request);
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(context, e.error);
      return;
    }

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()), (_) => false);
  }
}
