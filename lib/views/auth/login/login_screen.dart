import 'package:azkar/main.dart';
import 'package:azkar/net/payload/authentication/requests/email_login_request_body.dart';
import 'package:azkar/net/payload/authentication/responses/email_login_response.dart';
import 'package:azkar/net/payload/authentication/responses/facebook_authentication_response.dart';
import 'package:azkar/net/service_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Keys.loginScreen,
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
                        Container(
                          padding: EdgeInsets.all(100.0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).login,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Padding(
                                // Internalize that
                                padding: const EdgeInsets.only(right: 40.0),
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
                              left: 40.0, right: 40.0, top: 10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          padding:
                              // Internalize that
                              const EdgeInsets.only(left: 10.0, right: 0.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: TextFormField(
                                  obscureText: false,
                                  textAlign: TextAlign.left,
                                  onChanged: (email) => _email = email,
                                  validator: (email) {
                                    RegExp regex =
                                        new RegExp('^[\\w-_\\.+]*[\\w-_\\.]\\@'
                                            '([\\w]+\\.)+[\\w]+[\\w]\$');
                                    if (regex.stringMatch(email) != email) {
                                      return 'Email is invalid';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'email@example.com',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              left: 40.0, right: 40.0, top: 10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          padding:
                              // Internalize that
                              const EdgeInsets.only(left: 10.0, right: 0.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: TextFormField(
                                  obscureText: true,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  onChanged: (password) => _password = password,
                                  validator: (password) {
                                    if (password.length < 8) {
                                      return AppLocalizations.of(context)
                                          .passwordShouldBeOfAtLeast8Characters;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
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
                        // new Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: <Widget>[
                        //     Padding(
                        //       // internalize that
                        //       padding: const EdgeInsets.only(left: 20.0),
                        //       // ignore: deprecated_member_use
                        //       child: new FlatButton(
                        //         child: new Text(
                        //           AppLocalizations.of(context).forgotPassword,
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.black,
                        //             fontSize: 15.0,
                        //           ),
                        //           textAlign: TextAlign.end,
                        //         ),
                        //         onPressed: () => {},
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                                    if (_loginFormKey.currentState.validate()) {
                                      loginWithEmail(new EmailLoginRequestBody(
                                          email: _email, password: _password));
                                    }
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
                                            AppLocalizations.of(context).login,
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
                        new Container(
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
                        new Container(
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
                                                new BorderRadius.circular(30.0),
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
                                                    padding: EdgeInsets.only(
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
                                                        Icon(
                                                          const IconData(0xea90,
                                                              fontFamily:
                                                                  'icomoon'),
                                                          color: Colors.white,
                                                          size: 20.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                  padding: EdgeInsets.only(
                                                    // internalize that
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
                              testing(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )))),
    );
  }

  Widget testing() {
    return Row(
      children: [
        // ignore: deprecated_member_use
        FlatButton(
            onPressed: () {
              loginWithEmail(new EmailLoginRequestBody(
                  email: 'oyaraouf@gmail.com', password: 'omaromar'));
            },
            child: Text('oyaraouf')),
        // ignore: deprecated_member_use
        FlatButton(
            onPressed: () {
              loginWithEmail(new EmailLoginRequestBody(
                  email: 'oyasser826@gmail.com', password: 'omaromar'));
            },
            child: Text('oyasser826'))
      ],
    );
  }

  loginWithFacebook() async {
    FacebookAuthenticationResponse response =
        await ServiceProvider.authenticationService.loginWithFacebook();
    if (response.hasError()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new HomePage()));
    }
  }

  loginWithEmail(EmailLoginRequestBody request) async {
    EmailLoginResponse response =
        await ServiceProvider.authenticationService.login(request);

    if (!response.hasError()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    }
  }
}
