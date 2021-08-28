import 'package:azkar/net/cache_manager.dart';
import 'package:azkar/net/services/authentication_service.dart';
import 'package:azkar/net/services/categories_service.dart';
import 'package:azkar/net/services/challenges_service.dart';
import 'package:azkar/net/services/groups_service.dart';
import 'package:azkar/net/services/secure_storage_service.dart';
import 'package:azkar/net/services/users_service.dart';
import 'package:http/http.dart' as http;

/// Holds instances of the application services. This should be the main access
/// point to services used by widgets. That is to make mocking these services in
/// tests as easy as setting the service instance to the mock instance.
class ServiceProvider {
  static AuthenticationService authenticationService = AuthenticationService();
  static ChallengesService challengesService = ChallengesService();
  static UsersService usersService = UsersService();
  static GroupsService groupsService = GroupsService();
  static SecureStorageService secureStorageService = SecureStorageService();
  static CategoriesService azkarService = CategoriesService();
  static CacheManager cacheManager = CacheManager();
  static http.Client httpClient = http.Client();
}
