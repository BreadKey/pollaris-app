import 'dart:convert';

import 'package:pollaris_app/blocs/secret.dart';
import 'package:pollaris_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'authorizer.dart';

enum SignUpError {
  conflictId,
  conflictNickname,
  idLengthNotInRange,
  nicknameLengthNotIntRange,
  idNotMatchPattern,
  unknown
}

class AuthBloc {
  Future<bool> signIn(String id, String password) async {
    final response = await http.post(Uri.https(domain, "$stage/signIn"),
        body: json.encode({"id": id, "password": password}));

    if (response.statusCode == 200) {
      final auth = json.decode(response.body);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("accessToken", auth["accessToken"]);

      return true;
    }

    return false;
  }

  Future<SignUpError?> signUp(
      String id, String nickname, String password) async {
    final response = await http.post(Uri.https(domain, "$stage/signUp"),
        body: json.encode({
          "id": id,
          "nickname": nickname,
          "password": password,
          "roles": ["User"]
        }));

    if (response.statusCode == 201) {
      return null;
    } else {
      final String message = json.decode(response.body)["message"];
      if (message == "Conflict id") {
        return SignUpError.conflictId;
      } else if (message == "Conflict nickname") {
        return SignUpError.conflictNickname;
      } else if (message.contains("Id length not in range")) {
        return SignUpError.idLengthNotInRange;
      } else if (message.contains("Nickname length not in range")) {
        return SignUpError.nicknameLengthNotIntRange;
      } else if (message.contains("Id not match pattern")) {
        return SignUpError.idNotMatchPattern;
      }

      return SignUpError.unknown;
    }
  }

  Future<User?> authorize() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString("accessToken");

    if (accessToken == null) return null;

    final response = await http.get(Uri.https(domain, "$stage/auth"),
        headers: await authorizeUser());

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
  }

  Future<bool> requestVerificationCode(
      String userId, String phoneNumber) async {
    final response = await http.get(
        Uri.https(domain, "$stage/auth/verification",
            {"userId": userId, "phoneNumber": phoneNumber}),
        headers: await authorizeUser());

    print(response.body);

    return response.statusCode == 200;
  }

  Future<bool> verifyIdentity(String userId, String code) async {
    final response = await http.post(
        Uri.https(domain, "$stage/auth/verification"),
        body: json.encode({"userId": userId, "code": code}),
        headers: await authorizeUser());

    print(response.body);

    return response.statusCode == 200;
  }

  Future signOut() async {
    return Future.wait([
      http.delete(Uri.https(domain, "$stage/auth"),
          headers: await authorizeUser()),
      SharedPreferences.getInstance()
          .then((prefs) => prefs.remove("accessToken"))
    ]);
  }
}
