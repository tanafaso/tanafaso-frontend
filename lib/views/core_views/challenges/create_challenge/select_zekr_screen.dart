import 'dart:convert';

import 'package:azkar/main.dart';
import 'package:azkar/models/zekr.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/challenges/responses/get_azkar_response.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/zekr_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectZekrScreen extends StatefulWidget {
  final List<Zekr> azkar;

  SelectZekrScreen({@required this.azkar});

  @override
  _SelectZekrScreenState createState() => _SelectZekrScreenState();
}

class _SelectZekrScreenState extends State<SelectZekrScreen> {
  TextEditingController searchController;
  List<Zekr> filteredAzkar;

  @override
  void initState() {
    filteredAzkar = widget.azkar;
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        filterBy(searchController.value.text);
      });
    });
    super.initState();
  }

  void filterBy(String sequence) {
   filteredAzkar = [];
   for (Zekr zekr in widget.azkar) {
      if (zekr.zekr.contains(sequence)) {
        filteredAzkar.add(zekr);
      }
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectZekr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText:
                        AppLocalizations.of(context).searchForAZekr,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: filteredAzkar.length,
                      itemBuilder: (context, index) {
                        return ZekrWidget(zekr: filteredAzkar[index]);
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
