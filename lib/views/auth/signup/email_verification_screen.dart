import 'dart:async';

import 'package:azkar/main.dart';
import 'package:azkar/net/payload/authentication/requests/email_verification_request_body.dart';
import 'package:azkar/net/payload/authentication/responses/email_verification_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/auth/login/login_screen.dart';
import 'package:azkar/views/auth/signup/pin_code_text_field.dart';
import 'package:azkar/views/auth/signup/pin_theme.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  EmailVerificationScreen(this.phoneNumber);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController()
    ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: FlareActor(
                  "assets/images/otp.flr",
                  animation: "otp",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  AppLocalizations.of(context).emailVerification,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text:
                          AppLocalizations.of(context).enterTheCodeSentTo + " ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: Container(
                    height: 120,
                    child: PinCodeTextField(
                      length: 6,
                      obsecureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Theme.of(context).primaryColor,
                      enableActiveFill: false,
                      errorAnimationController: errorController,
//                    controller: textEditingController,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError
                      ? AppLocalizations.of(context)
                          .pleaseFillUpAllTheCellsProperly
                      : "",
                  style: TextStyle(color: Colors.red.shade300, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //       text: AppLocalizations.of(context).didNotReceiveTheCjode,
              //       style: TextStyle(color: Colors.black54, fontSize: 15),
              //       children: [
              //         TextSpan(
              //             text: AppLocalizations.of(context).resend,
              //             recognizer: onTapRecognizer,
              //             style: TextStyle(
              //                 color: Color(0xFF91D3B3),
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 16))
              //       ]),
              // ),
              // SizedBox(
              //   height: 14,
              // ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        performEmailVerification();
                      }
                    },
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context).verify,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     // ignore: deprecated_member_use
              //     FlatButton(
              //       child: Text(AppLocalizations.of(context).clear),
              //       onPressed: () {
              //         textEditingController.clear();
              //       },
              //     ),
              //     // ignore: deprecated_member_use
              //     // FlatButton(
              //     //   child: Text("Set Text"),
              //     //   onPressed: () {
              //     //     textEditingController.text = "123456";
              //     //   },
              //     // ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  void performEmailVerification() {
    ServiceProvider.authenticationService
        .verifyEmail(new EmailVerificationRequestBody(
            email: widget.phoneNumber, pin: int.parse(currentText)))
        .then<void>((EmailVerificationResponse value) {
      if (value.hasError()) {
        onEmailVerificationError();
      } else {
        onEmailVerificationSuccess();
      }
    });

    setState(() {
      hasError = false;
    });
  }

  void onEmailVerificationError() {
    errorController
        .add(ErrorAnimationType.shake); // Triggering error shake animation
    setState(() {
      hasError = true;
    });
  }

  void onEmailVerificationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green.shade300,
      content: Text(
        AppLocalizations.of(context).verificationSuccessful,
      ),
    ));
    hasError = false;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoginScreen()));
  }
}
