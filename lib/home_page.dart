import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  final String _error_message;

  HomePage(this._error_message);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userToken;

  Future<void> getUserToken() async {
    userToken = await FlutterSecureStorage().read(key: 'jwtToken');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserToken(),
      builder: (context, AsyncSnapshot snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
          ),
          body: Center(
            child: Text(widget._error_message ?? userToken ?? 'Default'),
          ),
        );
      },
    );
  }
}
