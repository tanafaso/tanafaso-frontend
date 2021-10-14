import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:azkar/views/core_views/challenges/do_challenge/do_memorization_challenge/memorization_challenge_step_done_callback.dart';
import 'package:flutter/material.dart';

class ChoicesWidget extends StatelessWidget {
  final List<Choice> choices;
  final MemorizationChallengeStepDoneCallback onCorrectChoiceSelected;

  ChoicesWidget({
    this.choices,
    this.onCorrectChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    choices.shuffle();

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) =>
          Padding(padding: EdgeInsets.only(bottom: 4)),
      shrinkWrap: true,
      itemCount: choices.length,
      itemBuilder: (context, index) {
        return RawMaterialButton(
          child: Text(choices[index].word),
          onPressed: () {
            if (choices[index].correct) {
              SnackBarUtils.showSnackBar(
                context,
                'اختيار صحيح',
                color: Colors.green.shade400,
              );
              onCorrectChoiceSelected.call();
            } else {
              SnackBarUtils.showSnackBar(
                context,
                'اختيار خاطئ ، حاول مرة أخرى',
              );
            }
          },
        );
      },
    );
  }
}

class Choice {
  final String word;
  final bool correct;

  Choice({
    @required this.word,
    this.correct,
  });
}
