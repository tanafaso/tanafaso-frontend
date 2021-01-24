import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/net/users_service.dart';
import 'package:azkar/views/entities/friends/friend_widget.dart';
import 'package:azkar/views/entities/friends/show_all_friends_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersService extends Mock implements UsersService {}

void main() {
  final MockUsersService usersService = MockUsersService();

  setUp(() {
    ServiceProvider.usersService = usersService;
  });

  testWidgets(
      'Expected widgets are found when there are some pending and some non-pending friends',
      (WidgetTester tester) async {
    List<Friend> pendingFriends = [
      Friend(
        userId: 'pendingUserId1',
        username: 'pendingUsername1',
        name: 'pendingName1',
        pending: true,
      ),
    ];

    List<Friend> nonPendingFriends = [
      Friend(
        userId: 'nonPendingUserId1',
        username: 'nonPendingUsername1',
        name: 'nonPendingName1',
        pending: false,
      ),
      Friend(
        userId: 'nonPendingUserId2',
        username: 'nonPendingUsername2',
        name: 'nonPendingName2',
        pending: false,
      ),
    ];

    List<Friend> allFriends = pendingFriends + nonPendingFriends;

    var friendsResponse = GetFriendsResponse(
      friendship: Friendship(
        id: 'friendshipId',
        userId: 'userId',
        friends: allFriends,
      ),
    );

    when(usersService.getFriends())
        .thenAnswer((_) => Future.value(friendsResponse));

    await tester.pumpWidget(new MaterialApp(home: ShowAllFriendsWidget()));
    await tester.pumpAndSettle();

    expect(find.byKey(Keys.showAllFriendsWidgetList), findsOneWidget);

    // Finds only two FriendWidgets, which are the two non-pending friends.
    expect(find.byType(FriendWidget), findsNWidgets(2));

    // Finds a card for the first non-pending friend.
    expect(
        find.descendant(
          of: find.byType(Card),
          matching: find.text(nonPendingFriends[0].username),
        ),
        findsOneWidget);

    // Finds a card for the second non-pending friend.
    expect(
        find.descendant(
          of: find.byType(Card),
          matching: find.text(nonPendingFriends[1].username),
        ),
        findsOneWidget);
  });
}
