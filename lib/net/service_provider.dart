import 'package:azkar/net/authentication_service.dart';
import 'package:azkar/net/challenges_service.dart';
import 'package:azkar/net/users_service.dart';

/// Holds instances of the application services. This should be the main access
/// point to services used by widgets. That is to make mocking these services in
/// tests as easy as setting the service instance to the mock instance.
class ServiceProvider {
  static AuthenticationService authenticationService =
      new AuthenticationService();
  static ChallengesService challengesService = new ChallengesService();
  static UsersService usersService = new UsersService();
}
