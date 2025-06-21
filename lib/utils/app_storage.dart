import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final _storage = GetStorage("battlespace");

  static void removeKey(String key) {
    _storage.remove(key);
  }

  static void setValue(String key, dynamic value) {
    _storage.write(key, value);
  }

  static dynamic valueFor(String key) {
    return _storage.read(key);
  }
}


class StorageKey {
  static String storageName = "battlespace";
  static String highScore = "high_score";
  static String userName = "username";
  static String userAvatar = "user_avatar";
  static String userCoins = "user_coins";
  static String musicSetting = "music_setting";
  static String sfxSetting = "sfx_setting";
  static String playerSprite = "player_sprite";
}