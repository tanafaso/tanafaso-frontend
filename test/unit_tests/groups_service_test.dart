import 'dart:convert';

import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/groups/requests/add_group_request_body.dart';
import 'package:azkar/net/payload/groups/responses/add_group_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

// Tests should always run with the localhost as a base URL.
// Note: route should start with '/'.
String getRouteWithBase(String route) {
  return ApiRoutesUtil.apiRouteToString(
          Endpoint(endpointRoute: EndpointRoute.LOCAL_HOST_BASE_URL)) +
      route;
}

main() {
  test(
      'add group returns the created group if the group is created successfully',
      () async {
    final client = MockClient();
    ServiceProvider.httpClient = client;

    const String groupName = "exampleGroupName";
    const String groupId = "exampleGroupId";
    const String userId = "exampleUserId";
    Map<String, dynamic> expectedResult = {
      "data": {
        "id": groupId,
        "name": groupName,
        "adminId": userId,
        "usersIds": ["example-admin-id"],
        "challengesIds": [],
        "binary": true
      },
      "error": null
    };
    when(client.post(getRouteWithBase('/groups'))).thenAnswer(
        (_) async => http.Response(jsonEncode(expectedResult), 200));

    AddGroupRequestBody requestBody = AddGroupRequestBody(name: groupName);
    AddGroupResponse response = await ServiceProvider.groupsService.addGroup(requestBody);

    expect(response.hasError(), false);
    expect(response.group.name, groupName);
  });

  test('throws an exception if the http call completes with an error', () {
    final client = MockClient();

    // Use Mockito to return an unsuccessful response when it calls the
    // provided http.Client.
    when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    expect(fetchPost(client), throwsException);
  });
}
