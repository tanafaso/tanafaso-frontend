import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Expected widgets are found', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: AuthMainScreen()));

    expect(find.byKey(Keys.AUTH_MAIN_SCREEN_SIGN_UP_TEXT), findsOneWidget);
    expect(find.byKey(Keys.AUTH_MAIN_SCREEN_SIGN_UP_BUTTON), findsOneWidget);
    expect(find.byKey(Keys.AUTH_MAIN_SCREEN_LOGIN_TEXT), findsOneWidget);
    expect(find.byKey(Keys.AUTH_MAIN_SCREEN_LOGIN_BUTTON), findsOneWidget);
    expect(find.byKey(Keys.AUTH_MAIN_SCREEN_FACEBOOK_TEXT), findsOneWidget);
    expect(find.byKey(Keys.AUTH_MAIN_SCREEN_FACEBOOK_BUTTON), findsOneWidget);
  });

  testWidgets('The sign up screen is pumped on tapping the sign up button',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: AuthMainScreen()));

    await tester.tap(find.byKey(Keys.AUTH_MAIN_SCREEN_SIGN_UP_BUTTON));
    await tester.pumpAndSettle();

    expect(find.byKey(Keys.SIGN_UP_MAIN_SCREEN), findsOneWidget);
  });

  testWidgets('The login screen is pumped on tapping the login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: AuthMainScreen()));

    await tester.tap(find.byKey(Keys.AUTH_MAIN_SCREEN_LOGIN_BUTTON));
    await tester.pumpAndSettle();

    expect(find.byKey(Keys.LOGIN_SCREEN), findsNWidgets(3));
  });

  // TODO(Add login with facebook tests)
}
