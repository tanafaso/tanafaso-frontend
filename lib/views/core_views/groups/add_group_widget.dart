import 'package:azkar/net/payload/groups/requests/add_group_request_body.dart';
import 'package:azkar/net/payload/groups/responses/add_group_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/groups/group_screen.dart';
import 'package:flutter/material.dart';

class AddGroupWidget extends StatefulWidget {
  @override
  _AddGroupWidgetState createState() => _AddGroupWidgetState();
}

class _AddGroupWidgetState extends State<AddGroupWidget> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Group'),
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(30)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Group name'),
                  validator: (groupName) {
                    if (groupName.isEmpty) {
                      return "Group name can not be empty";
                    }
                    if (groupName.length > 30) {
                      return "Group name is too long";
                    }
                    _groupName = groupName;
                    return null;
                  },
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        AddGroupResponse response = await ServiceProvider
                            .groupsService
                            .addGroup(AddGroupRequestBody(name: _groupName));
                        if (response.hasError()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response.error.errorMessage)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Group Added Successfully'),
                            backgroundColor: Colors.green.shade400,
                          ));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      GroupScreen(group: response.group)));
                        }
                      }
                    },
                    child: Center(
                        child: Text(
                      "CREATE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
            ],
          ),
        )));
  }
}
