import 'package:azkar/views/home_page.dart';
import 'package:azkar/net/authentication_service.dart';
import 'package:azkar/net/payload/authentication/requests/email_login_request.dart';
import 'package:azkar/net/payload/authentication/responses/email_login_response.dart';
import 'package:azkar/net/payload/authentication/responses/facebook_authentication_response.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginScreenScaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginScreenScaffoldKey,
      body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: new SingleChildScrollView(
                  child: Form(
                key: _loginFormKey,
                child: new Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.05), BlendMode.dstATop),
                      image: AssetImage('assets/images/mountains.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(100.0),
                          child: Center(
                            child: Icon(
                              Icons.headset_mic,
                              color: Colors.redAccent,
                              size: 50.0,
                            ),
                          ),
                        ),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: new Text(
                                  "EMAIL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
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
                                  color: Colors.redAccent,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
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
                                padding: const EdgeInsets.only(left: 40.0),
                                child: new Text(
                                  "PASSWORD",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
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
                                  color: Colors.redAccent,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: TextFormField(
                                  obscureText: true,
                                  textAlign: TextAlign.left,
                                  onChanged: (password) => _password = password,
                                  validator: (password) {
                                    if (password.length < 8) {
                                      return 'Password should be of at least 8 characters';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '*********',
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
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: new FlatButton(
                                child: new Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                onPressed: () => {},
                              ),
                            ),
                          ],
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 20.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    if (_loginFormKey.currentState.validate()) {
                                      loginWithEmail(new EmailLoginRequest(email: _email, password: _password));
                                    }
                                  },
                                  child: new Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 20.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: Text(
                                            "LOGIN",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
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
                                "OR LOGIN WITH",
                                style: TextStyle(
                                  color: Colors.grey,
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
                                                  child: new FlatButton(
                                                    onPressed: () =>
                                                    loginWithFacebook(),
                                                    padding: EdgeInsets.only(
                                                      top: 20.0,
                                                      bottom: 20.0,
                                                    ),
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
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
                                                            "FACEBOOK",
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
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
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )))),
    );
  }

  loginWithFacebook() async {
    FacebookAuthenticationResponse response =
        await AuthenticationService.loginWithFacebook();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new HomePage()));
  }

  loginWithEmail(EmailLoginRequest request) async {
    EmailLoginResponse response = await AuthenticationService.login(request);

    if (!response.hasError()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new HomePage()));
    } else {
      _loginScreenScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    }
  }
}
