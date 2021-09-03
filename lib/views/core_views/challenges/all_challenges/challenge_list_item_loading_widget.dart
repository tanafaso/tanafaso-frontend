import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChallengeListItemLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RawMaterialButton(
        onPressed: () {},
        fillColor: Colors.white,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[500],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 8)),
                    LineWidget(width: MediaQuery.of(context).size.width / 3),
                    Expanded(
                      child: Container(),
                    ),
                    Icon(
                      Icons.whatshot,
                      color: Colors.green,
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        child: LineWidget(
                            width: MediaQuery.of(context).size.width / 3),
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      LineWidget(width: MediaQuery.of(context).size.width / 3),
                      Padding(padding: EdgeInsets.all(8)),
                      LineWidget(
                          width: MediaQuery.of(context).size.width * 2 / 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
 Widget that represents the lines Loading in the widget.
  */
class LineWidget extends StatelessWidget {
  final double width;

  LineWidget({@required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height / 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 0.2),
        ],
      ),
    );
  }
}
