enum ApiRoute {
  BASE_URL,
  LOGIN_WITH_FACEBOOK,
  REGISTER_WITH_EMAIL,
  VERIFY_EMAIL,
  LOGIN_WITH_EMAIL,
  GET_AZKAR
}

class ApiRoutesUtil {
  static String apiRouteToString(ApiRoute route) {
    switch (route) {
      case ApiRoute.BASE_URL:
        return 'localhost:8080';
      case ApiRoute.LOGIN_WITH_FACEBOOK:
        return '/login/facebook';
      case ApiRoute.REGISTER_WITH_EMAIL:
        return '/register/email';
      case ApiRoute.VERIFY_EMAIL:
        return '/verify/email';
      case ApiRoute.LOGIN_WITH_EMAIL:
        return '/login/email';
      case ApiRoute.GET_AZKAR:
        return '/azkar';
      default:
        print('Route enum is not registered.');
    }
  }
}
