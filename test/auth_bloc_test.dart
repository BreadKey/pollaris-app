import 'package:flutter_test/flutter_test.dart';
import 'package:pollaris_app/blocs/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'secret.dart';

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc();
    SharedPreferences.setMockInitialValues({});
  });

  test("sign up with error", () async {
    SignUpError? error = await authBloc.signUp(id, "hello", password);
    expect(error, SignUpError.conflictId);

    error = await authBloc.signUp("hello", nickname, password);
    expect(error, SignUpError.conflictNickname);

    error = await authBloc.signUp("asdasdklqwlkdqnwlkej1231", "hello", password);
    expect(error, SignUpError.idLengthNotInRange);

    error = await authBloc.signUp("hello", "asdasdklqwlkdqnwlkej1231", password);
    expect(error, SignUpError.nicknameLengthNotIntRange);

    error = await authBloc.signUp("아이디123", "hello", password);
    expect(error, SignUpError.idNotMatchPattern);
  });

  test("authorize with no access token", () async {
    final user = await authBloc.authorize();

    expect(user, null);
  });

  test("authorize", () async {
    final succeed = await authBloc.signIn(id, password);

    expect(succeed, true);

    final user = await authBloc.authorize();

    expect(user != null, true);
  });
}
