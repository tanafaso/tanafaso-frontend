import 'package:azkar/models/publicly_available_user.dart';
import 'package:azkar/net/api_exception.dart';
import 'package:azkar/net/api_interface/status.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/friends/add_friend/find_friends/find_friends_not_publicly_available_widget.dart';
import 'package:azkar/views/core_views/friends/add_friend/find_friends/find_friends_publicly_available_widget.dart';
import 'package:azkar/views/core_views/friends/add_friend/find_friends/publicly_available_user_loading_widget.dart';
import 'package:flutter/material.dart';

class FindFriendsScreen extends StatefulWidget {
  @override
  _FindFriendsScreenState createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  Future<void> _neededData;
  List<PubliclyAvailableUser> _publiclyAvailableUsers;
  bool _isPubliclyAvailableUser;
  String _errorMessage;

  Future<void> getNeededData() async {
    try {
      _publiclyAvailableUsers =
          await ServiceProvider.usersService.getPubliclyAvailableUsers();
      _isPubliclyAvailableUser = true;
    } on ApiException catch (e) {
      if (e.errorStatus.code ==
          Status.USER_NOT_ADDED_TO_PUBLICLY_AVAILABLE_USERS_ERROR) {
        _isPubliclyAvailableUser = false;
      } else {
        _errorMessage = e.errorStatus.errorMessage;
      }
    }
    return Future.value();
  }

  @override
  void initState() {
    super.initState();

    _publiclyAvailableUsers = [];
    _isPubliclyAvailableUser = true;
    _errorMessage = null;
    _neededData = getNeededData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "ابحث عن صديق",
      )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
            future: _neededData,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_errorMessage != null) {
                  return Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SnapshotUtils.getErrorWidget(context, snapshot),
                      )
                    ],
                  );
                }

                if (!_isPubliclyAvailableUser) {
                  return FindFriendsNotPubliclyAvailableWidget(
                    onAddedToPubliclyAvailableUsersCallback: () {
                      setState(() {
                        _neededData = getNeededData();
                      });
                    },
                  );
                }
                return FindFriendsPubliclyAvailableWidget(
                  publiclyAvailableUsers: _publiclyAvailableUsers,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: List.generate(
                      5, (_) => PubliclyAvailableUserLoadingWidget()),
                );
              } else {
                return Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                          'حدثت مشكلة أثناء جلب قائمة المستخدمين الذين يمكن اكتشافهم'),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
