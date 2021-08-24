import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChallengeListItemLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 20,
            ),
            VerticalDivider(
              width: 3,
              color: Colors.black,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineWidget_(MediaQuery.of(context).size.width / 3),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.directions_run),
                    ),
                    LineWidget_(MediaQuery.of(context).size.width * 2 / 3),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.alarm),
                    ),
                    LineWidget_(MediaQuery.of(context).size.width * 2 / 3),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.circle),
                      ),
                      LineWidget_(MediaQuery.of(context).size.width * 2 / 3),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
 Widget that represents the lines Loading in the widget.
  */
class LineWidget_ extends StatelessWidget {
  final double width;

  LineWidget_(this.width);

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
