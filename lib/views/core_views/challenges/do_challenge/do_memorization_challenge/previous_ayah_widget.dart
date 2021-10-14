import 'package:azkar/models/memorization_challenge.dart';
import 'package:azkar/utils/quran_ayahs.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_memorization_challenge/choices_widget.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_memorization_challenge/memorization_challenge_step_done_callback.dart';
import 'package:flutter/material.dart';

class PreviousAyahQuestionWidget extends StatefulWidget {
  final Question question;
  final MemorizationChallengeStepDoneCallback onStepDone;
  final ScrollController scrollController;

  PreviousAyahQuestionWidget({
    @required this.question,
    @required this.onStepDone,
    @required this.scrollController,
  });

  @override
  _PreviousAyahQuestionWidgetState createState() =>
      _PreviousAyahQuestionWidgetState();
}

class _PreviousAyahQuestionWidgetState
    extends State<PreviousAyahQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      shrinkWrap: true,
      children: [
        Text('select previous ayah'),
        ChoicesWidget(
          choices: [
            Choice(
                word: QuranAyahs.ayahs[(widget.question.ayah - 1)],
                correct: true),
            Choice(
                word: QuranAyahs
                    .ayahs[widget.question.wrongPreviousAyahOptions[0]],
                correct: false),
            Choice(
                word: QuranAyahs
                    .ayahs[widget.question.wrongPreviousAyahOptions[1]],
                correct: false),
          ],
          onCorrectChoiceSelected: () => widget.onStepDone.call(),
        )
      ],
    );
  }
}
