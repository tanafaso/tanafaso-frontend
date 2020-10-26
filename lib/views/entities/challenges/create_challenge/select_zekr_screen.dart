import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_routes.dart';
import 'package:azkar/net/payload/challenges/responses/get_azkar_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectZekrWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiCaller.get(ApiRoute.GET_AZKAR),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            GetAzkarResponse response =
                GetAzkarResponse.fromJson(jsonDecode(snapshot.data.body));
            List<String> azkar = response.azkar;
            return Scaffold(
              appBar: AppBar(
                title: Text('Select Zekr'),
              ),
              body: Center(
                  child: ListView.separated(
                itemCount: azkar.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                        title: Text(
                      '${utf8.decode(azkar[index].codeUnits)}',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: new TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
                  );
                },
              )),
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
}
