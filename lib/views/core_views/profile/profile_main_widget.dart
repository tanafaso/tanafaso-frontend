import 'package:azkar/main.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

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
                Text(
                    '${AppLocalizations.of(context).name}: ${response.user.name}'),
                Text(
                    '${AppLocalizations.of(context).email}: ${response.user.email}'),
                Text(
                    '${AppLocalizations.of(context).username}: ${response.user.username}'),
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
