import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String JWT_TOKEN_STORAGE_KEY = 'jwtToken';
  static const String FACEBOOK_TOKEN_STORAGE_KEY = 'facebookAccessToken';
  static const String FACEBOOK_USER_ID_STORAGE_KEY = 'facebookUserId';

  Future<String> getFacebookToken() async {
    final _storage = FlutterSecureStorage();
    String facebookToken = await _storage.read(key: FACEBOOK_TOKEN_STORAGE_KEY);
    return facebookToken;
  }

  Future<String> getFacebookUserId() async {
    final _storage = FlutterSecureStorage();
    String facebookUserId = await _storage.read(key: FACEBOOK_USER_ID_STORAGE_KEY);
    return facebookUserId;
  }

  Future<String> getJwtToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: JWT_TOKEN_STORAGE_KEY);
  }

  Future<void> setFacebookToken(String facebookToken) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: FACEBOOK_TOKEN_STORAGE_KEY, value: facebookToken);
  }

  Future<void> setFacebookUserId(String userId) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: FACEBOOK_USER_ID_STORAGE_KEY, value: userId);
  }

  Future<void> setJwtToken(String jwtToken) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: JWT_TOKEN_STORAGE_KEY, value: jwtToken);
  }

  Future<void> clear() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: JWT_TOKEN_STORAGE_KEY);
    await _storage.delete(key: FACEBOOK_TOKEN_STORAGE_KEY);
  }

  Future<bool> userSignedIn() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: JWT_TOKEN_STORAGE_KEY);
    return (token?.length ?? 0) != 0;
  }
}
