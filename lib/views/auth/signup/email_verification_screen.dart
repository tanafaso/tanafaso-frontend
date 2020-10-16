import 'dart:async';

import 'package:azkar/net/authentication.dart';
import 'package:azkar/payload/authentication/requests/email_verification_request.dart';
import 'package:azkar/payload/authentication/responses/email_verification_response.dart';
import 'package:azkar/views/auth/login/login_screen.dart';
import 'package:azkar/views/auth/signup/pin_code_text_field.dart';
import 'package:azkar/views/auth/signup/pin_theme.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      backgroundColor: Colors.blue.shade50,
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
                  'Email Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
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
                      backgroundColor: Colors.blue.shade50,
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
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(color: Colors.red.shade300, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFF91D3B3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
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
                      "VERIFY".toUpperCase(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                  FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "123456";
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void performEmailVerification() {
    Authentication.verifyEmail(new EmailVerificationRequest(
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
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Aye!!"),
        duration: Duration(seconds: 2),
      ));
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
    Fluttertoast.showToast(
        msg: "Verification Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: new Color.fromARGB(180, 105, 240, 174),
        textColor: Colors.white,
        fontSize: 16.0);
    hasError = false;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoginScreen()));
  }
}
