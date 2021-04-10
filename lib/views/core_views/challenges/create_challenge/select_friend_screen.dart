import 'dart:convert';

import 'package:azkar/models/friend.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiCaller.get(
            route: Endpoint(endpointRoute: EndpointRoute.GET_FRIENDS)),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            GetFriendsResponse response = GetFriendsResponse.fromJson(
                jsonDecode(utf8.decode(snapshot.data.body.codeUnits)));
            return Scaffold(
              appBar: AppBar(
                title: Text('Select a friend'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    buildWidgetWithFriends(response?.friendship?.friends ?? []),
              ),
            );
          } else if (snapshot.hasError) {
            // TODO(omorsi): Handle error
            return Text('Error');
          } else {
            // TODO(omorsi): Show loader
            return Text('Waiting');
          }
        });
  }

  Widget buildWidgetWithFriends(List<Friend> friends) {
    if (friends?.isEmpty ?? false) {
      return Center(
        child: Text('You have not added any friends yet.'),
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      padding: EdgeInsets.only(bottom: 8),
      itemBuilder: (context, index) {
        return getFriendCard(context, friends[index]);
      },
    );
  }

  Widget getFriendCard(BuildContext context, Friend friend) {
    return Container(
      child: GestureDetector(
        onTap: () => Navigator.pop(context, friend),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        friend.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 8)),
                Row(
                  children: [
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Username',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        friend.username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
}
