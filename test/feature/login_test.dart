import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  setUp(() {
    debugPrint("Here");
  });
  test("User login Fail Test", () {
    final isUserLogin = true;

    expect(isUserLogin, isTrue);
  });

  group("User login full test ", () {
    // Test1
    test("User login Fail Test", () {
      final isUserLogin = true;

      expect(isUserLogin, isTrue);
    });
    //Test2
    test("User login Fail Test", () {
      final isUserLogin = true;

      expect(isUserLogin, isTrue);
    });
    //Test3
    test("User login Fail Test", () {
      final isUserLogin = true;

      expect(isUserLogin, isTrue);
    });
  });
}
