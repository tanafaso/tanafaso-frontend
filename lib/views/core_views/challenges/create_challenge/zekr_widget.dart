import 'package:flutter/material.dart';

class ZekrWidget extends StatefulWidget {
  final String zekr;

  ZekrWidget({@required this.zekr});

  @override
  _ZekrWidgetState createState() => _ZekrWidgetState();
}

class _ZekrWidgetState extends State<ZekrWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, widget.zekr),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10,
        child: ListTile(
            title: Text(
          widget.zekr,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: new TextStyle(
            fontSize: 20.0,
          ),
        )),
      ),
    );
  }
}
