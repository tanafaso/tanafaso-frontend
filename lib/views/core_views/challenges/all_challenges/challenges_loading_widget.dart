import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 25, 10, 1),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
                  child: Column(
                    children: [
                      LineWidget(150.0, 8.0),
                      SizedBox(
                        width: 0,
                        height: 13,
                      ),
                      LineWidget(120.0, 8.0),
                    ],
                  )),
            ],
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 60, 0),
              child: Column(
                children: [
                  LineWidget(290.0, 8.0),
                  SizedBox(
                    height: 13,
                  ),
                  LineWidget(250.0, 8.0),
                  SizedBox(
                    height: 13,
                  ),
                  LineWidget(200.0, 8.0),
                ],
              )),
        ],
      ),
    );
  }
}
/*
Widget that represents the lines Loading in the widget.
 */
class LineWidget extends StatelessWidget {
  final double width;
  final double height;
  LineWidget(this.width, this.height);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
