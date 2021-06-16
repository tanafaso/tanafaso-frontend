import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/authentication/requests/email_registration_request_body.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
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
  FocusNode lastNameFocus;
  FocusNode emailFocus;
  FocusNode passwordFocus;
  FocusNode repeatedPasswordFocus;
  String _confirmedPassword;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    lastNameFocus = new FocusNode();
    emailFocus = new FocusNode();
    passwordFocus = new FocusNode();
    repeatedPasswordFocus = new FocusNode();
    _firstName = "";
    _lastName = "";
    _email = "";
    _password = "";
    _confirmedPassword = "";
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: Keys.signUpMainScreen,
        appBar: AppBar(
          title: Text("إنشاء حساب"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
          key: _signUpFormKey,
          child: new Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 4 * 8.0)),
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
                          left: 16.0, right: 16.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (name) => _firstName = name,
                              onEditingComplete: () =>
                                  lastNameFocus.requestFocus(),
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
                          left: 16.0, right: 16.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              focusNode: lastNameFocus,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (name) => _lastName = name,
                              onEditingComplete: () =>
                                  emailFocus.requestFocus(),
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
                          left: 16.0, right: 16.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              focusNode: emailFocus,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'email@example.com',
                              ),
                              onChanged: (email) => _email = email,
                              onEditingComplete: () =>
                                  passwordFocus.requestFocus(),
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
                          left: 16.0, right: 16.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              obscureText: _passwordObscure,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              focusNode: passwordFocus,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: GestureDetector(
                                  onTap: () {
                                    setState(() =>
                                        _passwordObscure = !_passwordObscure);
                                  },
                                  child: const Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.grey,
                                      )),
                                ),
                                hintText: AppLocalizations.of(context)
                                    .passwordHintText,
                              ),
                              onChanged: (password) => _password = password,
                              onEditingComplete: () =>
                                  repeatedPasswordFocus.requestFocus(),
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
                              AppLocalizations.of(context).confirmPassword,
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
                          left: 16.0, right: 16.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              obscureText: _repeatedPasswordObscure,
                              focusNode: repeatedPasswordFocus,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              onChanged: (password) =>
                                  _confirmedPassword = password,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: GestureDetector(
                                  onTap: () {
                                    setState(() => _repeatedPasswordObscure =
                                        !_repeatedPasswordObscure);
                                  },
                                  child: const Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.grey,
                                      )),
                                ),
                                hintText: AppLocalizations.of(context)
                                    .passwordHintText,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          // ignore: deprecated_member_use
                          child: new FlatButton(
                            child: new Text(
                              AppLocalizations.of(context).alreadyHaveAnAccount,
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
                                      builder: (context) => new LoginScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
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
                          left: 30.0, right: 30.0, top: 16.0, bottom: 10),
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            // ignore: deprecated_member_use
                            child: new FlatButton(
                              color: Theme.of(context).buttonColor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                if (_firstName.length < 2) {
                                  setState(() {
                                    _errorMessage = AppLocalizations.of(context)
                                        .nameShouldBeOfAtLeast2Letters;
                                  });
                                  return;
                                }
                                if (_lastName.length < 2) {
                                  setState(() {
                                    _errorMessage = AppLocalizations.of(context)
                                        .nameShouldBeOfAtLeast2Letters;
                                  });
                                  return;
                                }

                                RegExp regex =
                                    new RegExp('^[\\w-_\\.+]*[\\w-_\\.]\\@'
                                        '([\\w]+\\.)+[\\w]+[\\w]\$');
                                if (regex.stringMatch(_email) != _email) {
                                  setState(() {
                                    _errorMessage = AppLocalizations.of(context)
                                        .emailIsInvalid;
                                  });
                                  return;
                                }

                                if (_password.length < 8) {
                                  setState(() {
                                    _errorMessage = AppLocalizations.of(context)
                                        .passwordShouldBeOfAtLeast8Characters;
                                  });
                                  return;
                                }

                                if (_confirmedPassword != _password) {
                                  setState(() {
                                    _errorMessage = AppLocalizations.of(context)
                                        .passwordsDidNotMatch;
                                  });
                                  return;
                                }

                                performSignUp();
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
                                        AppLocalizations.of(context).signUp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
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
                  ],
                ),
              )),
        ))),
      ),
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
      SnackBarUtils.showSnackBar(context, e.error);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new AuthMainScreen()),
          (_) => false);
    }
  }
}
