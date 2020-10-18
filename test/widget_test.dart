// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:s_timesheet_mobile/core/crypto/rsa_crypto.dart';
import 'package:flutter/widgets.dart';
void main() {
  test("Dataa", () async {
    expect(Crypto.endCryptData, "Nguyễn Hữu Bình");
  });
}
