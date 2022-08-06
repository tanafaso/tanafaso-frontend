import 'dart:io';

import 'package:azkar/services/cache_manager.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/views/core_views/layout_organizer.dart';
import 'package:azkar/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingWidget extends StatefulWidget {
  @override
  _LandingWidgetState createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await clearSecureStorageOnce();

      bool isSignedIn =
          await ServiceProvider.secureStorageService.userSignedIn();
      if (mounted) {
        if (isSignedIn) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LayoutOrganizer()),
              (_) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => OnboardingScreen()),
              (_) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
                child: Icon(
              Icons.directions_run,
              color: Colors.green.shade800,
            )),
          )
        ],
      ),
    );
  }

  // Fixes the freezing issue that happens on app updates with the
  // solution mentioned in: https://github.com/mogol/flutter_secure_storage/issues/53.
  Future<void> clearSecureStorageOnce() async {
    SharedPreferences prefs = await ServiceProvider.cacheManager.getPrefs();
    if (Platform.isAndroid &&
        !prefs.containsKey(
            CacheManager.CACHE_KEY_CLEARED_SECURE_STORAGE_ANDROID)) {
      final _storage = FlutterSecureStorage();
      await _storage.deleteAll();
      prefs.setBool(
          CacheManager.CACHE_KEY_CLEARED_SECURE_STORAGE_ANDROID, true);
    }
    return Future.value();
  }
}
