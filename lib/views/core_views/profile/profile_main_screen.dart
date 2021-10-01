import 'package:auto_size_text/auto_size_text.dart';
import 'package:azkar/models/user.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:azkar/views/core_views/profile/profile_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  _ProfileMainScreenState createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  Future<void> _neededData;
  User _user;
  int _userScore;

  Future<void> getNeededData() async {
    _user = await ServiceProvider.usersService.getCurrentUser();
    _userScore =
        await ServiceProvider.challengesService.getFinishedChallengesCount();
  }

  @override
  void initState() {
    super.initState();

    _neededData = getNeededData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
              future: _neededData,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _user != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  _user.firstName + " " + _user.lastName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 8 * 3.0)),
                              RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.white,
                                onPressed: () {},
                                // elevation: 15,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            'كود المستخدم',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            _user.username,
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 8)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTapDown: (_) {
                                              Clipboard.setData(ClipboardData(
                                                text: _user.username,
                                              )).then((_) {
                                                SnackBarUtils.showSnackBar(
                                                    context,
                                                    AppLocalizations.of(context)
                                                        .usernameCopiedSuccessfully);
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.copy,
                                                  size: 25,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8)),
                                                AutoSizeText(
                                                  'نسخ الكود',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTapDown: (_) {
                                              Share.share(
                                                  AppLocalizations.of(context)
                                                      .shareMessage(
                                                          _user.username));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.share,
                                                  size: 25,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8)),
                                                AutoSizeText(
                                                  'مشاركة الكود مع صديق',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fillColor: Colors.white,
                            onPressed: () {},
                            // elevation: 15,
                            child: Container(
                              alignment: Alignment.center,
                              height: 300,
                              // width: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      AppLocalizations.of(context)
                                          .youHaveFinished,
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                      ArabicUtils.englishToArabic(
                                          _userScore.toString()),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 60,
                                        color: Colors.green,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      AppLocalizations.of(context).challenges,
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Container(
                            child: ButtonTheme(
                              height: 50,
                              // ignore: deprecated_member_use
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.grey,
                                onPressed: () async {
                                  performLogout(context);
                                },
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    AppLocalizations.of(context).logout,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ),
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
                        child: ButtonTheme(
                          height: 50,
                          // ignore: deprecated_member_use
                          child: RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fillColor: Colors.grey,
                            onPressed: () async {
                              performLogout(context);
                            },
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                AppLocalizations.of(context).logout,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return ProfileLoadingWidget();
                }
              }),
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
