import 'package:flutter_test/flutter_test.dart';
import 'package:pollaris_app/blocs/auth_bloc.dart';
import 'package:pollaris_app/blocs/poll_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'secret.dart';

void main() {
  test("get poll", () async {
    SharedPreferences.setMockInitialValues({});

    final authBloc = AuthBloc();

    expect(await authBloc.signIn(id, password), true);

    final pollBloc = PollBloc();

    final firstPage = await pollBloc.page();

    firstPage.forEach((element) {
      print(element.question);
    });
  });
}
