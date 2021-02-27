import 'dart:convert';

import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/groups/requests/add_group_request_body.dart';
import 'package:azkar/net/payload/groups/responses/add_group_response.dart';
import 'package:azkar/net/secure_storage_service.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

// Tests should always run with the localhost as a base URL.
// Note: route should start with '/'.
Uri getRouteWithBase(String route) {
  return Uri.http(
      ApiRoutesUtil.apiRouteToString(
          Endpoint(endpointRoute: EndpointRoute.LOCAL_HOST_BASE_URL)),
      route);
}

var client;
var secureStorageService;

initTest() {
  TestWidgetsFlutterBinding.ensureInitialized();
  client = MockClient();
  secureStorageService = MockSecureStorageService();
  ServiceProvider.httpClient = client;
  ServiceProvider.secureStorageService = secureStorageService;
}

main() {
  test(
      'add group returns the created group if the group is created successfully',
      () async {
    initTest();
    const String groupName = "exampleGroupName";
    const String groupId = "exampleGroupId";
    const String userId = "exampleUserId";
    Map<String, dynamic> expectedResult = {
      "data": {
        "id": groupId,
        "name": groupName,
        "adminId": userId,
        "usersIds": [userId],
        "challengesIds": [],
        "binary": true
      },
      "error": null
    };
    when(client.post(getRouteWithBase('/groups'),
            body: jsonEncode({'name': groupName}),
            headers: anyNamed('headers')))
        .thenAnswer(
            (_) async => http.Response(jsonEncode(expectedResult), 200));
    when(secureStorageService.setJwtToken(any))
        .thenAnswer((_) async => "jwtTokenExample");

    AddGroupRequestBody requestBody = AddGroupRequestBody(name: groupName);
    AddGroupResponse response =
        await ServiceProvider.groupsService.addGroup(requestBody);

    expect(response.hasError(), isFalse);
    expect(response.group.name, groupName);
    expect(response.group.adminId, userId);
    expect(response.group.usersIds.length, 1);
    expect(response.group.usersIds[0], userId);
  });

  test('sets the error if the server returns an error', () async {
    initTest();

    const String groupName = "exampleGroupName";
    const String expectedErrorMessage = "error message";
    Map<String, dynamic> expectedResult = {
      "error": {"message": expectedErrorMessage}
    };
    when(client.post(getRouteWithBase('/groups'),
            body: jsonEncode({'name': groupName}),
            headers: anyNamed('headers')))
        .thenAnswer(
            (_) async => http.Response(jsonEncode(expectedResult), 400));
    when(secureStorageService.setJwtToken(any))
        .thenAnswer((_) async => "jwtTokenExample");

    AddGroupRequestBody requestBody = AddGroupRequestBody(name: groupName);
    AddGroupResponse response =
        await ServiceProvider.groupsService.addGroup(requestBody);

    expect(response.hasError(), isTrue);
    expect(response.error.errorMessage, expectedErrorMessage);
  });
}
