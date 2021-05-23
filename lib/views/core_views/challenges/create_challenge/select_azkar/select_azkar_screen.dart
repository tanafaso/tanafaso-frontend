import 'dart:collection';

import 'package:azkar/models/sub_challenge.dart';
import 'package:azkar/models/zekr.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_azkar/zekr_widget.dart';
import 'package:flutter/material.dart';

class SelectAzkarScreen extends StatefulWidget {
  final List<Zekr> azkar;

  SelectAzkarScreen({@required this.azkar});

  @override
  _SelectAzkarScreenState createState() => _SelectAzkarScreenState();
}

class _SelectAzkarScreenState extends State<SelectAzkarScreen> {
  Map<int, SubChallenge> zekrIdToSubChallenge;
  TextEditingController searchController;
  Set<int> filteredAzkarIds;

  @override
  void initState() {
    super.initState();
    filteredAzkarIds = HashSet();
    // All azkar are included at the beginning.
    widget.azkar.forEach((zekr) {
      filteredAzkarIds.add(zekr.id);
    });
    zekrIdToSubChallenge = HashMap();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        filterBy(searchController.value.text);
      });
    });
  }

  void filterBy(String sequence) {
    filteredAzkarIds = HashSet();
    for (Zekr zekr in widget.azkar) {
      if (ArabicUtils.normalize(zekr.zekr).contains(sequence)) {
        filteredAzkarIds.add(zekr.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).selectAzkar),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Card(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).searchForAZekr,
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Card(
                    child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: widget.azkar.length,
                        itemBuilder: (context, index) {
                          return ZekrWidget(
                            visible:
                                filteredAzkarIds.contains(widget.azkar[index].id),
                            zekr: widget.azkar[index],
                            onRepetitionsChangedCallback: onRepetitionsChanged,
                          );
                        }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 8, bottom: 3 * 8.0),
                child: Container(
                  child: ButtonTheme(
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () => onCreatePressed(),
                      child: Center(
                          child: Text(
                        readyToFinish()
                            ? AppLocalizations.of(context).add
                            : AppLocalizations.of(context).addNotReady,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color:
                        readyToFinish() ? Colors.green.shade300 : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  onCreatePressed() async {
    if (!readyToFinish()) {
      SnackBarUtils.showSnackBar(
        context,
        AppLocalizations.of(context).pleaseSelectAzkarFirst,
      );
      return;
    }

    List<SubChallenge> selectedAzkar = [];
    zekrIdToSubChallenge.forEach((_, subChallenge) {
      selectedAzkar.add(subChallenge);
    });
    Navigator.pop(context, selectedAzkar);
  }

  bool readyToFinish() {
    return zekrIdToSubChallenge.length != 0;
  }

  void onRepetitionsChanged(SubChallenge newSubChallenge) {
    setState(() {
      if (newSubChallenge.repetitions == 0) {
        zekrIdToSubChallenge.remove(newSubChallenge.zekr.id);
      } else {
        zekrIdToSubChallenge.update(
            newSubChallenge.zekr.id, (value) => newSubChallenge,
            ifAbsent: () => newSubChallenge);
      }
    });
  }
}
