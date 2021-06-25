import 'package:azkar/models/friend.dart';
import 'package:azkar/models/friendship_scores.dart';
import 'package:azkar/net/services/service_provider.dart';
import 'package:azkar/net/services/users_service.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/views/core_views/friends/all_friends/all_friends_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/no_friends_found_widget.dart';
import 'package:azkar/views/core_views/friends/all_friends/summary_friend_list_item_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:feature_discovery/feature_discovery.dart';
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
      'friend list item widgets are found when the user has some friends',
      (WidgetTester tester) async {
    var friendScore1 = FriendshipScores(
        currentUserScore: 1,
        friendScore: 2,
        friend: Friend(
          userId: 'userId1',
          groupId: 'groupId2',
          username: 'username1',
          firstName: 'firstName1',
          lastName: 'lastName1',
          pending: false,
        ));

    var friendScore2 = FriendshipScores(
        currentUserScore: 2,
        friendScore: 3,
        friend: Friend(
          userId: 'userId2',
          groupId: 'groupId2',
          username: 'username2',
          firstName: 'firstName2',
          lastName: 'lastName2',
          pending: false,
        ));

    var friendScore3 = FriendshipScores(
        currentUserScore: 50,
        friendScore: 20,
        friend: Friend(
          userId: 'userId3',
          groupId: 'groupId3',
          username: 'username3',
          firstName: 'firstName3',
          lastName: 'lastName3',
          pending: false,
        ));

    var friendsLeaderboard = [friendScore1, friendScore2, friendScore3];

    when(usersService.getFriendsLeaderboard())
        .thenAnswer((_) => Future.value(friendsLeaderboard));

    await tester.pumpWidget(FeatureDiscovery(
      child: new MaterialApp(
        home: AllFriendsWidget(),
        localizationsDelegates: [AppLocalizationsDelegate()],
        supportedLocales: [
          const Locale('ar', ''),
        ],
      ),
    ));
    await tester.pumpAndSettle(Duration(milliseconds: 2000));

    expect(find.byKey(Keys.allFriendsWidgetListKey), findsOneWidget);

    expect(find.byType(SummaryFriendListItemWidget), findsNWidgets(3));

    // expect(
    //     find.descendant(
    //       of: find.byType(SummaryFriendListItemWidget),
    //       matching: find.textContaining(friendScore1.friend.firstName),
    //     ),
    //     findsOneWidget);
    //
    // expect(
    //     find.descendant(
    //       of: find.byType(SummaryFriendListItemWidget),
    //       matching: find.textContaining(friendScore2.friend.firstName),
    //     ),
    //     findsOneWidget);
    //
    // expect(
    //     find.descendant(
    //       of: find.byType(SummaryFriendListItemWidget),
    //       matching: find.textContaining(friendScore3.friend.firstName),
    //     ),
    //     findsOneWidget);
  });

  testWidgets(
      'a message showing that the friend list is empty is shown when the user has no friends',
      (WidgetTester tester) async {
    when(usersService.getFriendsLeaderboard())
        .thenAnswer((_) => Future.value([]));

    await tester.pumpWidget(new MaterialApp(
      home: AllFriendsWidget(),
      localizationsDelegates: [AppLocalizationsDelegate()],
      supportedLocales: [
        const Locale('ar', ''),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.byType(NoFriendsFoundWidget), findsOneWidget);
  });
}
