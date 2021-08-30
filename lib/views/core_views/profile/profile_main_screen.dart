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
    _userScore = _user.getFinishedChallengesCount();
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
                                child: Text(
                                  _user.firstName + " " + _user.lastName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _user.username,
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
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
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    GestureDetector(
                                      onTapDown: (_) {
                                        Share.share(AppLocalizations.of(context)
                                            .shareMessage(_user.username));
                                      },
                                      child: Icon(
                                        Icons.share,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 20, bottom: 8),
                            child: Container(
                              alignment: Alignment.center,
                              child: Visibility(
                                visible: (_user?.email ?? null) != null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_user?.email ??
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
                                      AppLocalizations.of(context)
                                          .youHaveFinished,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  Text(
                                      ArabicUtils.englishToArabic(
                                          _userScore.toString()),
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
