import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsMainScreen extends StatefulWidget {
  @override
  _SettingsMainScreenState createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  RepeatInterval _currentlySelectedRepeatValue;

  @override
  void initState() {
    super.initState();

    _currentlySelectedRepeatValue = RepeatInterval.weekly;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RepeatInterval preferredRepeatInterval = await ServiceProvider
          .localNotificationsService
          .getCurrentNudgeInterval();
      if (mounted) {
        setState(() {
          _currentlySelectedRepeatValue = preferredRepeatInterval;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "الإعدادات",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(8)),
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(
                              "ذكرني بتحدي أصدقائي",
                            ),
                            DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                minWidth: 0,
                                child: DropdownButton<RepeatInterval>(
                                  value: _currentlySelectedRepeatValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.black,
                                  elevation: 4,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  onChanged: (RepeatInterval newValue) {
                                    ServiceProvider.localNotificationsService
                                        .setNudgeInterval(newValue);
                                    setState(() {
                                      _currentlySelectedRepeatValue = newValue;
                                    });
                                  },
                                  items: <RepeatInterval>[
                                    RepeatInterval.daily,
                                    RepeatInterval.weekly,
                                  ].map<DropdownMenuItem<RepeatInterval>>(
                                      (RepeatInterval repeatInterval) {
                                    return DropdownMenuItem<RepeatInterval>(
                                      value: repeatInterval,
                                      child: Text(
                                          ServiceProvider
                                              .localNotificationsService
                                              .nudgeIntervalToString(
                                                  repeatInterval),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  performLogout(BuildContext context) async {
    await ServiceProvider.secureStorageService.clear();
    await ServiceProvider.cacheManager.clearPreferences();
    SnackBarUtils.showSnackBar(
        context, AppLocalizations.of(context).youHaveLoggedOutSuccessfully);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new AuthMainScreen()),
        (_) => false);
  }
}
