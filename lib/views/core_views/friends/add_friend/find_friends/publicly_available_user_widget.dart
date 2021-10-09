import 'package:azkar/models/publicly_available_user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';

class PubliclyAvailableUserWidget extends StatefulWidget {
  final PubliclyAvailableUser publiclyAvailableUser;

  PubliclyAvailableUserWidget({@required this.publiclyAvailableUser});

  @override
  _PubliclyAvailableUserWidgetState createState() =>
      _PubliclyAvailableUserWidgetState();
}

class _PubliclyAvailableUserWidgetState
    extends State<PubliclyAvailableUserWidget> {
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
                    '${widget.publiclyAvailableUser.firstName} ${widget.publiclyAvailableUser.lastName}',
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
          .addFriendWithId(widget.publiclyAvailableUser.userId);
    } on ApiException catch (e) {
      SnackBarUtils.showSnackBar(
        context,
        '${AppLocalizations.of(context).error}: ${e.errorStatus.errorMessage}',
      );
      return;
    }

    SnackBarUtils.showSnackBar(
      context,
      '${AppLocalizations.of(context).anInvitationHasBeenSentTo} ${widget.publiclyAvailableUser.firstName} ${widget.publiclyAvailableUser.lastName}',
      color: Colors.green.shade400,
    );

    setState(() {
      invited = true;
    });
  }
}
