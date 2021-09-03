import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: LineWidget(
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineWidget(
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ),
                        Icon(
                          Icons.copy,
                          size: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        Icon(
                          Icons.share,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 20, bottom: 8),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LineWidget(
                          width: MediaQuery.of(context).size.width * 2 / 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(30)),
              Card(
                elevation: 0,
                child: Container(
                  alignment: Alignment.center,
                  height: 300,
                  width: 300,
                  child: Container(),
                ),
              ),
            ],
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
