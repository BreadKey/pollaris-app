import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> authorizeUser() async {
  final prefs = await SharedPreferences.getInstance();

  return {"Authorization": "bearer ${prefs.getString("accessToken")}"};
}