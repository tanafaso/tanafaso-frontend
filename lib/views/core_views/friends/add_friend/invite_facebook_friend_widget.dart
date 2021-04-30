import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';

class InviteFacebookFriendWidget extends StatefulWidget {
  final User facebookFriend;

  InviteFacebookFriendWidget({@required this.facebookFriend});

  @override
  _InviteFacebookFriendWidgetState createState() =>
      _InviteFacebookFriendWidgetState();
}

class _InviteFacebookFriendWidgetState
    extends State<InviteFacebookFriendWidget> {
  bool invited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shadowColor: Colors.black,
        elevation: 10,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.facebookFriend.firstName} ${widget.facebookFriend.lastName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Expanded(child: conditionallyGetInviteButton()),
          ],
        ),
      ),
    );
  }

  Widget conditionallyGetInviteButton() {
    // ignore: deprecated_member_use
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        child: invited
            ? Text(AppLocalizations.of(context).invited)
            : Text(AppLocalizations.of(context).invite),
        color: invited ? null : Colors.green.shade400,
        onPressed: () => invited ? null : onInvitePressed(),
      ),
    );
  }

  void onInvitePressed() async {
    try {
      await ServiceProvider.usersService
          .addFriend(widget.facebookFriend.username);
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
        context,
        '${AppLocalizations.of(context).error}: ${e.error}',
      );
    }

    SnackBarUtils.showSnackBar(
      context,
      '${AppLocalizations.of(context).anInvitationHasBeenSentTo} ${widget.facebookFriend.firstName} ${widget.facebookFriend.lastName}',
      color: Colors.green.shade400,
    );

    setState(() {
      invited = true;
    });
  }
}
