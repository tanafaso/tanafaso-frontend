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

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.person,
                        //   size: 40,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: VerticalDivider(
                        //     width: 3,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                response.user.firstName +
                                    " " +
                                    response.user.lastName,
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
                                      response.user.username + "@",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTapDown: (_) {
                                      Clipboard.setData(ClipboardData(
                                        text: response.user.username,
                                      )).then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .usernameCopiedSuccessfully),
                                        ));
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              response.user
                                  .getFinishedChallengesCount()
                                  .toString(),
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
                ],
              ),
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
