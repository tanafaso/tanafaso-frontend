import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/users_service.dart';
import 'package:azkar/views/entities/friends/friends_widget.dart';
import 'package:azkar/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class AddFriendWidget extends StatefulWidget {
  final FriendsWidgetState friendsWidgetState;

  AddFriendWidget({Key key, @required this.friendsWidgetState})
      : super(key: key) {
    HomePage.setAppBarTitle('Add Friend');
  }

  @override
  _AddFriendWidgetState createState() => _AddFriendWidgetState();
}

class _AddFriendWidgetState extends State<AddFriendWidget> {
  final _formKey = GlobalKey<FormState>();

  String _friend_username;
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Enter a username",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                onChanged: (String username) {
                  _friend_username = username;
                },
                validator: (val) {
                  if (val.contains(" ")) {
                    return "Username should have no spaces";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(10),
            ),
            buildTextWithIcon(),
          ],
        ),
      ),
    );
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: "Invite",
            icon: Icon(Icons.add, color: Colors.white),
            color: Theme.of(context).primaryColor),
        ButtonState.loading:
            IconedButton(text: "Sending", color: Colors.deepPurple.shade700),
        ButtonState.fail: IconedButton(
            text: "Failed",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: "Sent",
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: onPressedIconWithText,
      state: stateTextWithIcon,
    );
  }

  void onPressedIconWithText() {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        if (!_formKey.currentState.validate()) {
          break;
        }

        setState(() {
          stateTextWithIcon = ButtonState.loading;
        });

        addFriend();
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIcon = stateTextWithIcon;
    });
  }

  void addFriend() async {
    AddFriendResponse response = await UsersService.addFriend(_friend_username);
    if (response.hasError()) {
      setState(() {
        stateTextWithIcon = ButtonState.fail;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
      return;
    }

    setState(() {
      stateTextWithIcon = ButtonState.success;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
          'An invitation to ${_friend_username} has been sent successfully.'),
    ));
  }
}
