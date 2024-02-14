import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static SharedPreferences? _preference;
  static const String key = 'userType';

  static init() async {
    _preference = await SharedPreferences.getInstance();
    return _preference;
  }

  static Future saveUserType(String type) async {
    return await _preference!.setString(key, type);
  }

  static Future<String>? getUserType() async =>
      // ignore: await_only_futures
      await _preference!.getString(key) ?? '';
}
