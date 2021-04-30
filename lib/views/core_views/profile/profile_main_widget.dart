import 'package:azkar/models/user.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_numbers_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileMainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(AppLocalizations.of(context).profile);

    return FutureBuilder(
        future: ServiceProvider.usersService.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  user.firstName + " " + user.lastName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user.username + "@",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTapDown: (_) {
                                        Clipboard.setData(ClipboardData(
                                          text: user.username,
                                        )).then((_) {
                                          SnackBarUtils.showSnackBar(
                                              context,
                                              AppLocalizations.of(context)
                                                  .usernameCopiedSuccessfully);
                                        });
                                      },
                                      child: Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 20, bottom: 8),
                      child: Container(
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: (user?.email ?? null) != null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                size: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user?.email ??
                                    AppLocalizations.of(context)
                                        .noEmailProvided),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Card(
                      elevation: 15,
                      child: Container(
                        alignment: Alignment.center,
                        height: 300,
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context).youHaveFinished,
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Text(
                                ArabicNumbersUtils.englishToArabic(user
                                    .getFinishedChallengesCount()
                                    .toString()),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  color: Colors.green,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context).challenges,
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: ButtonTheme(
                        height: 50,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () async {
                            performLogout(context);
                          },
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context).logout,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SnapshotUtils.getErrorWidget(context, snapshot),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: ButtonTheme(
                    height: 50,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () async {
                        performLogout(context);
                      },
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context).logout,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            );
          } else {
            // TODO(omorsi): Show loader
            return Text(AppLocalizations.of(context).loading);
          }
        });
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
