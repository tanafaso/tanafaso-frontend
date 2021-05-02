import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class LandingWidget extends StatefulWidget {
  @override
  _LandingWidgetState createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isSignedIn =
          await ServiceProvider.secureStorageService.userSignedIn();
      if (isSignedIn) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()), (_) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthMainScreen()),
            (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
