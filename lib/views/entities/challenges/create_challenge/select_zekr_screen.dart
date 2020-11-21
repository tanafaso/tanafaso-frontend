import 'dart:convert';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/responses/get_azkar_response.dart';
import 'package:azkar/views/entities/challenges/create_challenge/zekr_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectZekrWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiCaller.get(
            route: Endpoint(endpointRoute: EndpointRoute.GET_AZKAR)),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            GetAzkarResponse response =
                GetAzkarResponse.fromJson(jsonDecode(snapshot.data.body));
            List<String> azkar = response.azkar;
            return Scaffold(
              appBar: AppBar(
                title: Text('Select Zekr'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: ListView.builder(
                  itemCount: azkar.length,
                  itemBuilder: (context, index) {
                    return ZekrWidget(zekr: azkar[index]);
                  },
                )),
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
}
