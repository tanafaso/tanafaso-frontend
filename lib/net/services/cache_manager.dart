import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  // This design assumes that we will at most need to hash 1000 different
  // categories of information.
  static const String CACHE_KEY_CURRENT_USER_ID = "000";
  static const String CACHE_KEY_USER_FULL_NAME_PREFIX = "001";
  static const String CACHE_KEY_GROUP_ID_PREFIX = "002";
  static const String CACHE_KEY_ORIGINAL_CHALLENGE_PREFIX = "002";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<SharedPreferences> getPrefs() async {
    return await _prefs;
  }

  Future<void> clearPreferences() async {
    SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
