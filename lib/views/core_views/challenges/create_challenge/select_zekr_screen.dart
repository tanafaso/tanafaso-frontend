import 'dart:convert';

import 'package:azkar/main.dart';
import 'package:azkar/models/zekr.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/responses/get_azkar_response.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/zekr_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectZekrScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiCaller.get(
            route: Endpoint(endpointRoute: EndpointRoute.GET_AZKAR)),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            GetAzkarResponse response = GetAzkarResponse.fromJson(
                jsonDecode(utf8.decode(snapshot.data.body.codeUnits)));
            List<Zekr> azkar = response.azkar;
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).selectZekr),
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
            return Text(AppLocalizations.of(context).error);
          } else {
            // TODO(omorsi): Show loader
            return Text(AppLocalizations.of(context).loading);
          }
        });
  }
}
