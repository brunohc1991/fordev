import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/pages/pages.dart';

void main() {
  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text));

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          "When a TextFormField has only one text child, means it has no errors, since onde of the childs is always the label text.",
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          "When a TextFormField has only one text child, means it has no errors, since onde of the childs is always the label text.",
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });
}
