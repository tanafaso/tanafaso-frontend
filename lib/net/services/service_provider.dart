import 'package:azkar/net/services/authentication_service.dart';
import 'package:azkar/net/cache_manager.dart';
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
  static AuthenticationService authenticationService =
      new AuthenticationService();
  static ChallengesService challengesService = new ChallengesService();
  static UsersService usersService = new UsersService();
  static GroupsService groupsService = new GroupsService();
  static SecureStorageService secureStorageService = new SecureStorageService();
  static CategoriesService azkarService = new CategoriesService();
  static CacheManager cacheManager = new CacheManager();
  static http.Client httpClient = http.Client();
}
