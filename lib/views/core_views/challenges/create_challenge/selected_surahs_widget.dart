import 'package:azkar/models/friendship.dart';
import 'package:azkar/models/readingQuranChallenge.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/arabic_utils.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/create_challenge/select_surah_screen.dart';
import 'package:flutter/material.dart';

typedef OnSelectedSurahsChanged = void Function(
    List<SurahSubChallenge> newSelectedSurahs);

class SelectedSurahsWidget extends StatefulWidget {
  final List<SurahSubChallenge> initiallySelectedSurahs;
  final OnSelectedSurahsChanged onSelectedSurahsChanged;

  SelectedSurahsWidget(
      {this.initiallySelectedSurahs = const [],
      @required this.onSelectedSurahsChanged});

  @override
  _SelectedSurahsWidgetState createState() => _SelectedSurahsWidgetState();
}

class _SelectedSurahsWidgetState extends State<SelectedSurahsWidget>
    with AutomaticKeepAliveClientMixin {
  List<SurahSubChallenge> _selectedSurahs;

  @override
  void initState() {
    super.initState();

    _selectedSurahs = [];
    this.widget.initiallySelectedSurahs.forEach((initiallySelectedSurah) {
      _selectedSurahs.add(initiallySelectedSurah);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Necessary as documented by AutomaticKeepAliveClientMixin.
    super.build(context);

    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.list),
              ),
              getTitle(),
            ],
          ),
          Visibility(
            visible: (_selectedSurahs?.length ?? 0) != 0,
            maintainSize: false,
            child: getSelectedSurahs(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) => 10),
                  shape: MaterialStateProperty.resolveWith((_) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
              onPressed: () async {
                Friendship friendship;
                try {
                  friendship = await ServiceProvider.usersService.getFriends();
                } on ApiException catch (e) {
                  SnackBarUtils.showSnackBar(
                    context,
                    e.error,
                  );
                  return;
                }
                SurahSubChallenge selectedSurahSubChallenge =
                    await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSurahScreen(),
                  ),
                ) as SurahSubChallenge;

                setState(() {
                  _selectedSurahs.add(selectedSurahSubChallenge);
                  widget.onSelectedSurahsChanged(_selectedSurahs);
                });
              },
              child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitle() {
    String text;
    Color color;
    if ((_selectedSurahs?.length ?? 0) == 0) {
      text = "لم يتم اختيار أية سور";
      color = Colors.pink;
    } else {
      text = "السور المختارة";
      color = Colors.black;
    }
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color),
    );
  }

  Widget getSelectedSurahs() {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.only(left: 8 * 3.0, right: 8),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 8),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            shrinkWrap: true,
            itemCount: _selectedSurahs.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                      children: [
                        TextSpan(text: _selectedSurahs[index].surahName),
                        TextSpan(text: ' من آية رقم '),
                        TextSpan(
                            text: ArabicUtils.englishToArabic(
                                _selectedSurahs[index]
                                    .startingVerseNumber
                                    .toString()),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                          text: ' إلى الآية رقم ',
                        ),
                        TextSpan(
                            text: ArabicUtils.englishToArabic(
                                _selectedSurahs[index]
                                    .endingVerseNumber
                                    .toString()),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSurahs.removeAt(index);
                        widget.onSelectedSurahsChanged(_selectedSurahs);
                      });
                    },
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
