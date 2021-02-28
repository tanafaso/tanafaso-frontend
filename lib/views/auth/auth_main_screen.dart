import 'package:azkar/net/payload/authentication/responses/facebook_authentication_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/auth/login/login_screen.dart';
import 'package:azkar/views/auth/signup/signup_main_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class AuthMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                        flex: 8,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: EdgeInsets.only(top: 200.0),
                          child: Center(
                              // TODO: Add icon
                              ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Azkar",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 8,
                        fit: FlexFit.tight,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                // ignore: deprecated_member_use
                                child: new OutlineButton(
                                  key: Keys.authMainScreenSignUpButton,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  color: Theme.of(context).primaryColor,
                                  highlightedBorderColor: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpMainScreen()));
                                  },
                                  child: new Container(
                                    height: double.infinity,
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
                                            'SIGN UP',
                                            key: Keys.authMainScreenSignUpText,
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
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                // ignore: deprecated_member_use
                                child: new FlatButton(
                                  key: Keys.authMainScreenLoginButton,
                                  height: double.infinity,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  color: Colors.white,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen())),
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
                                            'LOGIN',
                                            key: Keys.authMainScreenLoginText,
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
                      ),
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 30.0),
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
                                "OR LOGIN WITH",
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
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                // ignore: deprecated_member_use
                                child: new FlatButton(
                                  key: Keys.authMainScreenFacebookButton,
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
                                        new Expanded(
                                          // ignore: deprecated_member_use
                                          child: new FlatButton(
                                            onPressed: () =>
                                                loginWithFacebook(context),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 20.0,
                                              horizontal: 20.0,
                                            ),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  const IconData(0xea90,
                                                      fontFamily: 'icomoon'),
                                                  color: Colors.white,
                                                  size: 20.0,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'FACEBOOK',
                                                    key: Keys
                                                        .authMainScreenFacebookText,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                      Flexible(
                        flex: 8,
                        fit: FlexFit.tight,
                        child: Container(),
                      ),
                    ],
                  ),
                )))));
  }

  loginWithFacebook(BuildContext context) async {
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
}
