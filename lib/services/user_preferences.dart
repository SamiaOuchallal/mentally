import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String keyDarkMode = "dark_mode";

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkMode, value);
  }

  static Future<void> setStressLevel(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("stress_level", value);
  }

  static Future<double> getStressLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("stress_level") ?? 5.0;
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_name") ?? "";
  }

  static Future<int> getUserAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_age") ?? 0;
  }

  static Future<String> getUserGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_gender") ?? "";
  }

  static Future<void> setUserAge(int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("user_age", age);
  }

  static Future<void> setUserGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_gender", gender);
  }
}
