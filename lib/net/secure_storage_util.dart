import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  static const String JWT_TOKEN_STORAGE_KEY = 'jwtToken';
  static const String FACEBOOK_TOKEN_STORAGE_KEY = 'facebookAccessToken';

  static Future<String> getFacebookToken() async {
    final _storage = FlutterSecureStorage();
    String facebookToken = await _storage.read(key: FACEBOOK_TOKEN_STORAGE_KEY);
    // TODO(omar): Check that the token is not expired.
    return facebookToken;
  }

  static Future<String> getJwtToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: JWT_TOKEN_STORAGE_KEY);
  }

  static Future<void> setFacebookToken(String facebookToken) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: FACEBOOK_TOKEN_STORAGE_KEY, value: facebookToken);
  }

  static Future<void> setJwtToken(String jwtToken) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: JWT_TOKEN_STORAGE_KEY, value: jwtToken);
  }
}
