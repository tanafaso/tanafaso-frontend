import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 16,
          MediaQuery.of(context).size.height / 16, 0, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height / 8,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              Column(
                children: [
                  LineWidget(MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.height / 80),
                  SizedBox(
                    width: 0,
                    height: 13,
                  ),
                  LineWidget(MediaQuery.of(context).size.width * 0.4,
                      MediaQuery.of(context).size.height / 80),
                ],
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 100, 0),
              child: Column(
                children: [
                  LineWidget(MediaQuery.of(context).size.width * 0.4,
                      MediaQuery.of(context).size.height / 80),
                  SizedBox(
                    height: 13,
                  ),
                  LineWidget(MediaQuery.of(context).size.width * 0.6,
                      MediaQuery.of(context).size.height / 80),
                  SizedBox(
                    height: 13,
                  ),
                  LineWidget(MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height / 80),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('تحدي'),
          )
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
