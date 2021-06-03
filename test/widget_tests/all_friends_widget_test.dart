import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/net/users_service.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/core_views/friends/all_friends/all_friends_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/detailed_friend_list_item_widget.dart';
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
      'friend list item widgets are found when there are some pending and some non-pending friends',
      (WidgetTester tester) async {
    List<Friend> pendingFriends = [
      Friend(
        userId: 'pendingUserId1',
        groupId: 'groupId1',
        username: 'pendingUsername1',
        firstName: 'pendingFirstName1',
        lastName: 'pendingLastName1',
        pending: true,
      ),
    ];

    List<Friend> nonPendingFriends = [
      Friend(
        userId: 'nonPendingUserId1',
        groupId: 'groupId2',
        username: 'nonPendingUsername1',
        firstName: 'nonPendingFirstName1',
        lastName: 'nonPendingLastName1',
        pending: false,
      ),
      Friend(
        userId: 'nonPendingUserId2',
        groupId: 'groupId3',
        username: 'nonPendingUsername2',
        firstName: 'nonPendingFirstName2',
        lastName: 'nonPendingLastName2',
        pending: false,
      ),
    ];

    List<Friend> allFriends = pendingFriends + nonPendingFriends;

    var friendship = Friendship(
      id: 'friendshipId',
      userId: 'userId',
      friends: allFriends,
    );

    when(usersService.getFriends()).thenAnswer((_) => Future.value(friendship));

    await tester.pumpWidget(new MaterialApp(
      home: AllFriendsWidget(),
      localizationsDelegates: [AppLocalizationsDelegate()],
      supportedLocales: [
        const Locale('ar', ''),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.byKey(Keys.allFriendsWidgetListKey), findsOneWidget);

    // Finds only two FriendWidgets, which are the two non-pending friends.
    expect(find.byType(DetailedFriendListItemWidget), findsNWidgets(2));

    // Finds a card for the first non-pending friend.
    expect(
        find.descendant(
          of: find.byType(Card),
          matching: find.textContaining(nonPendingFriends[0].firstName),
        ),
        findsOneWidget);

    // Finds a card for the second non-pending friend.
    expect(
        find.descendant(
          of: find.byType(Card),
          matching: find.textContaining(nonPendingFriends[1].lastName),
        ),
        findsOneWidget);
  });

  testWidgets(
      'a message showing that the friend list is empty is shown when the user has no friends',
      (WidgetTester tester) async {
    when(usersService.getFriends()).thenAnswer((_) => Future.value(Friendship(
          id: "example-id",
          userId: "example-user-id",
          friends: [],
        )));

    await tester.pumpWidget(new MaterialApp(
      home: AllFriendsWidget(),
      localizationsDelegates: [AppLocalizationsDelegate()],
      supportedLocales: [
        const Locale('ar', ''),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.byType(AllFriendsWidget), findsOneWidget);
    expect(find.byKey(Keys.allFriendsWidgetNoFriendsFoundKey), findsOneWidget);
  });
}
