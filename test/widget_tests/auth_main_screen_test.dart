import 'package:azkar/views/auth/auth_main_screen.dart';
import 'package:azkar/views/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Expected widgets are found', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: AuthMainScreen()));

    expect(find.byKey(Keys.authMainScreenSignUpText), findsOneWidget);
    expect(find.byKey(Keys.authMainScreenSignUpButton), findsOneWidget);
    expect(find.byKey(Keys.authMainScreenLoginText), findsOneWidget);
    expect(find.byKey(Keys.authMainScreenLoginButton), findsOneWidget);
    expect(find.byKey(Keys.authMainScreenFacebookText), findsOneWidget);
    expect(find.byKey(Keys.authMainScreenFacebookButton), findsOneWidget);
  });

  testWidgets('The sign up screen is pumped on tapping the sign up button',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: AuthMainScreen()));

    await tester.tap(find.byKey(Keys.authMainScreenSignUpButton));
    await tester.pumpAndSettle();

    expect(find.byKey(Keys.signUpMainScreen), findsOneWidget);
  });

  testWidgets('The login screen is pumped on tapping the login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: AuthMainScreen()));

    await tester.tap(find.byKey(Keys.authMainScreenLoginButton));
    await tester.pumpAndSettle();

    expect(find.byKey(Keys.loginScreen), findsOneWidget);
  });

  // TODO(Add login with facebook tests)
}
