import 'dart:convert';

import 'package:azkar/models/user.dart';
import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/api_routes.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<GetUserResponse> getCurrentUser() async {
    http.Response response =
        await ApiCaller.get(ApiRoute.GET_CURRENT_USER_PROFILE);
    return GetUserResponse.fromJson(jsonDecode(response.body));
  }
}
