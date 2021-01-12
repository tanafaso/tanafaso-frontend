import 'package:azkar/net/payload/authentication/requests/email_registration_request_body.dart';
import 'package:azkar/net/payload/authentication/responses/email_registration_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/auth/login/login_screen.dart';
import 'package:azkar/views/auth/signup/email_verification_screen.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';

class SignUpMainScreen extends StatefulWidget {
  @override
  _SignUpMainScreenState createState() {
    _SignUpMainScreenState state = new _SignUpMainScreenState();
    return state;
  }
}

class _SignUpMainScreenState extends State<SignUpMainScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Keys.SIGN_UP_MAIN_SCREEN,
      body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Form(
                  key: _signUpFormKey,
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
                    child: ListView(
                      children: [
                        new Column(
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
                                      "NAME",
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
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 10.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Name Example',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (name) => _name = name,
                                      validator: (name) {
                                        if (name.length < 2) {
                                          return 'Name should be of at least 2 letters';
                                        }
                                        return null;
                                      },
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
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 10.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'email@example.com',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (email) => _email = email,
                                      validator: (email) {
                                        RegExp regex = new RegExp(
                                            '^[\\w-_\\.+]*[\\w-_\\.]\\@'
                                            '([\\w]+\\.)+[\\w]+[\\w]\$');
                                        if (regex.stringMatch(email) != email) {
                                          return 'Email is invalid';
                                        }
                                        return null;
                                      },
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
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 10.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      obscureText: true,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '*********',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (password) =>
                                          _password = password,
                                      validator: (password) {
                                        if (password.length < 8) {
                                          return 'Password should be of at least 8 characters';
                                        }
                                        return null;
                                      },
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
                                      "CONFIRM PASSWORD",
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
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 10.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      obscureText: true,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '*********',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      validator: (confirmedPassword) {
                                        if (confirmedPassword != _password) {
                                          print(confirmedPassword.length
                                                  .toString() +
                                              " " +
                                              _password.length.toString());
                                          return 'Passwords did not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 24.0,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: new FlatButton(
                                    child: new Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  new LoginScreen()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 30.0,
                                  right: 30.0,
                                  top: 50.0,
                                  bottom: 10),
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new FlatButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      color: Colors.redAccent,
                                      onPressed: () {
                                        if (_signUpFormKey.currentState
                                            .validate()) {
                                          performSignUp();
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
                                                "SIGN UP",
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }

  void performSignUp() async {
    ServiceProvider.authenticationService
        .signUp(new EmailRegistrationRequestBody(
            email: _email, password: _password, name: _name))
        .then<void>((EmailRegistrationResponse response) {
      if (response.hasError()) {
        onSignUpError(response.error.errorMessage);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new EmailVerificationScreen(_email)));
      }
    });
  }

  void onSignUpError(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Error"),
              content: Text(errorMessage),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"),
                )
              ],
            ));
  }
}
