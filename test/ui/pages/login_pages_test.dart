import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

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

  testWidgets('Should call validate with corret values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });
}
