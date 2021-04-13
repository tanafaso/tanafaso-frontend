import 'package:azkar/main.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileMainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle(AppLocalizations.of(context).profile);

    return FutureBuilder(
        future: ServiceProvider.usersService.getCurrentUser(),
        builder:
            (BuildContext context, AsyncSnapshot<GetUserResponse> snapshot) {
          if (snapshot.hasData) {
            GetUserResponse response = snapshot.data;

            if (response.hasError()) {
              return Text(response.error.errorMessage);
            }

            return Column(
              children: [
                Container(
                    child: Column(children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(response.user.firstName +
                                  " " +
                                  response.user.lastName),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ])),
                Container(
                    child: Column(children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(response.user.email),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ])),
                Container(
                    child: Column(children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(response.user.username),
                            ),
                            GestureDetector(
                              onTapDown: (_) {
                                Clipboard.setData(ClipboardData(
                                  text: response.user.username,
                                )).then((_) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context)
                                        .usernameCopiedSuccessfully),
                                  ));
                                });
                              },
                              child: Icon(Icons.copy),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
                Container(
                    child: Column(children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  AppLocalizations.of(context).youHaveFinished),
                            ),
                            Text(
                              response.user
                                  .getFinishedChallengesCount()
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(AppLocalizations.of(context).challenges),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
              ],
            );
          } else if (snapshot.hasError) {
            // TODO(omorsi): Handle error
            return Text('Error');
          } else {
            // TODO(omorsi): Show loader
            return Text(AppLocalizations.of(context).loading);
          }
        });
  }
}
