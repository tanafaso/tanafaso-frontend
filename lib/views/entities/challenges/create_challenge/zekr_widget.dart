import 'package:flutter/material.dart';
import 'dart:convert';


class ZekrWidget extends StatefulWidget {
  final String zekr;


  ZekrWidget({@required this.zekr});

  @override
  _ZekrWidgetState createState() => _ZekrWidgetState();
}

class _ZekrWidgetState extends State<ZekrWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 10,
      child: ListTile(
          title: Text(
        '${utf8.decode(widget.zekr.codeUnits)}',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: new TextStyle(
          fontSize: 20.0,
        ),
      )),
    );
  }
}
