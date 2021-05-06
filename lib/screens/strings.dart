library strings;

import 'package:flutter/material.dart';

part 'strings/ko.dart';

abstract class Strings {
  String get appName => "Pollaris";
  String get signIn;
  String get signUp;
  String get signOut;
  String get id;
  String get nickname;
  String get password;
  String get confirmPassword;
  String get enterId;
  String get enterNickname;
  String get enterPasword;
  String get notMatchPassword;
  String get signInFailed;
  String get verifyIdentity;
  String get requestVerificationCode;
  String get invalidCode;

  const Strings._();

  factory Strings.of(BuildContext context) => const _KoStrings();
}