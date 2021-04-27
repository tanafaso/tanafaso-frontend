import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/payload/authentication/requests/email_registration_request_body.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/auth/auth_main_screen.dart';
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
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  bool _passwordObscure = true;
  bool _repeatedPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Keys.signUpMainScreen,
      body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Form(
                  key: _signUpFormKey,
                  child: new Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: ListView(
                      children: [
                        new Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(100.0),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).signUp,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Padding(
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: new Text(
                                      AppLocalizations.of(context).firstName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                  const EdgeInsets.only(left: 10.0, right: 0.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)
                                              .firstNameExample),
                                      onChanged: (name) => _firstName = name,
                                      validator: (name) {
                                        if (name.length < 2) {
                                          return AppLocalizations.of(context)
                                              .nameShouldBeOfAtLeast2Letters;
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
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: new Text(
                                      AppLocalizations.of(context).lastName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                  const EdgeInsets.only(left: 10.0, right: 0.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)
                                              .lastNameExample),
                                      onChanged: (name) => _lastName = name,
                                      validator: (name) {
                                        if (name.length < 2) {
                                          return AppLocalizations.of(context)
                                              .nameShouldBeOfAtLeast2Letters;
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
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: new Text(
                                      AppLocalizations.of(context).email,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                  const EdgeInsets.only(left: 10.0, right: 0.0),
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
                                      ),
                                      onChanged: (email) => _email = email,
                                      validator: (email) {
                                        RegExp regex = new RegExp(
                                            '^[\\w-_\\.+]*[\\w-_\\.]\\@'
                                            '([\\w]+\\.)+[\\w]+[\\w]\$');
                                        if (regex.stringMatch(email) != email) {
                                          return AppLocalizations.of(context)
                                              .emailIsInvalid;
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
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: new Text(
                                      AppLocalizations.of(context).password,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                  const EdgeInsets.only(left: 10.0, right: 0.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      obscureText: _passwordObscure,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
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
                                      ),
                                      onChanged: (password) =>
                                          _password = password,
                                      validator: (password) {
                                        if (password.length < 8) {
                                          return AppLocalizations.of(context)
                                              .passwordShouldBeOfAtLeast8Characters;
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
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: new Text(
                                      AppLocalizations.of(context)
                                          .confirmPassword,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                  const EdgeInsets.only(left: 10.0, right: 0.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      obscureText: _repeatedPasswordObscure,
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: GestureDetector(
                                          onTap: () {
                                            setState(() =>
                                                _repeatedPasswordObscure =
                                                    !_repeatedPasswordObscure);
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
                                      ),
                                      validator: (confirmedPassword) {
                                        if (confirmedPassword != _password) {
                                          return AppLocalizations.of(context)
                                              .passwordsDidNotMatch;
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
                                  padding: const EdgeInsets.only(left: 20.0),
                                  // ignore: deprecated_member_use
                                  child: new FlatButton(
                                    child: new Text(
                                      AppLocalizations.of(context)
                                          .alreadyHaveAnAccount,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                    // ignore: deprecated_member_use
                                    child: new FlatButton(
                                      color: Theme.of(context).buttonColor,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
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
                                                AppLocalizations.of(context)
                                                    .signUp,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new EmailVerificationScreen(_email)));
    try {
      await ServiceProvider.authenticationService
          .signUp(new EmailRegistrationRequestBody(
        email: _email,
        password: _password,
        firstName: _firstName,
        lastName: _lastName,
      ));
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.error),
      ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new AuthMainScreen()),
          (_) => false);
    }
  }
}
