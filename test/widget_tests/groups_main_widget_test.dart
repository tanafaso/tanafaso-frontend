import 'package:azkar/views/core_views/groups/all_groups/all_groups_widget.dart';
import 'package:azkar/views/core_views/groups/create_group/add_group_widget.dart';
import 'package:azkar/views/core_views/groups/group_invitations/group_invitations_widget.dart';
import 'package:azkar/views/core_views/groups/groups_main_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  pumpAndSettleGroupsMainWidget(WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: HomePage()));
    var homePage = find.byType(HomePage).evaluate().single.widget as HomePage;
    homePage
        .selectNavigationBarItemForTesting(HomePageNavigationBarItem.groups);

    await tester.pumpAndSettle();
  }

  testWidgets('Expected widgets are found', (WidgetTester tester) async {
    await pumpAndSettleGroupsMainWidget(tester);

    expect(find.byType(GroupsMainWidget), findsOneWidget);
    expect(find.byKey(Keys.groupsMainWidgetFloatingButton), findsOneWidget);
    expect(find.byKey(Keys.groupsMainWidgetTabBar), findsOneWidget);
    expect(find.byKey(Keys.groupsMainWidgetAllGroupsTabKey), findsOneWidget);
    expect(find.byKey(Keys.groupsMainWidgetGroupInvitationsTabKey),
        findsOneWidget);
    expect(find.byType(AllGroupsWidget), findsOneWidget);
  });

  testWidgets(
      'Switches correctly between widgets showing groups and invitations',
      (WidgetTester tester) async {
    await pumpAndSettleGroupsMainWidget(tester);

    // Initial state
    expect(find.byType(AllGroupsWidget), findsOneWidget);
    expect(find.byType(GroupInvitationsWidget), findsNothing);

    // Show group invitations
    await tester.tap(find.byKey(Keys.groupsMainWidgetGroupInvitationsTabKey));
    await tester.pumpAndSettle();
    expect(find.byType(AllGroupsWidget), findsNothing);
    expect(find.byType(GroupInvitationsWidget), findsOneWidget);

    // Show all groups
    await tester.tap(find.byKey(Keys.groupsMainWidgetAllGroupsTabKey));
    await tester.pumpAndSettle();
    expect(find.byType(AllGroupsWidget), findsOneWidget);
    expect(find.byType(GroupInvitationsWidget), findsNothing);
  });

  testWidgets('New screen shows when create group button is pressed',
      (WidgetTester tester) async {
    await pumpAndSettleGroupsMainWidget(tester);

    expect(find.byType(GroupsMainWidget), findsOneWidget);
    expect(find.byKey(Keys.groupsMainWidgetFloatingButton), findsOneWidget);

    await tester.tap(find.byKey(Keys.groupsMainWidgetFloatingButton));
    await tester.pumpAndSettle();

    expect(find.byType(AddGroupWidget), findsOneWidget);
    expect(find.byType(GroupsMainWidget), findsNothing);
  });
}
