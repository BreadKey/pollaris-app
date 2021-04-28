import 'package:flutter_test/flutter_test.dart';

void main() {
  test("utc to local", () {
    final utcDateTime = "2021-04-28 06:02:14";
    final localDateTime = DateTime.parse(utcDateTime + 'Z').toLocal();

    expect(localDateTime.hour, 15);
  });
}