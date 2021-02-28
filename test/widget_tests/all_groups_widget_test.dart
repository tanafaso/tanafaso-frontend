import 'package:azkar/models/user_group.dart';
import 'package:azkar/net/groups_service.dart';
import 'package:azkar/net/payload/groups/responses/get_groups_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/core_views/groups/all_groups_widget.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGroupsService extends Mock implements GroupsService {}

void main() {
  final MockGroupsService groupsService = new MockGroupsService();
  ServiceProvider.groupsService = groupsService;

  testWidgets('group list item widgets are found when user groups exist',
      (WidgetTester tester) async {
    GetGroupsResponse expectedResponse = GetGroupsResponse();
    const String groupName1 = "Group name1";
    const String groupName2 = "Group name 2";
    expectedResponse.userGroups
        .add(UserGroup(groupId: "groupId1", groupName: groupName1));
    expectedResponse.userGroups
        .add(UserGroup(groupId: "groupId2", groupName: groupName2));
    when(groupsService.getGroups())
        .thenAnswer((_) => Future.value(expectedResponse));

    await tester.pumpWidget(new MaterialApp(home: AllGroupsWidget()));
    await tester.pumpAndSettle();

    expect(find.byType(AllGroupsWidget), findsOneWidget);
    expect(find.text(groupName1), findsOneWidget);
    expect(find.text(groupName2), findsOneWidget);
  });

  testWidgets(
      'a message showing that the group list is empty is shown when the user has no groups',
      (WidgetTester tester) async {
    when(groupsService.getGroups())
        .thenAnswer((_) => Future.value(GetGroupsResponse()));

    await tester.pumpWidget(new MaterialApp(home: AllGroupsWidget()));
    await tester.pumpAndSettle();

    expect(find.byType(AllGroupsWidget), findsOneWidget);
    expect(find.byKey(Keys.allGroupsWidgetNoGroupsFoundKey), findsOneWidget);
  });
}
