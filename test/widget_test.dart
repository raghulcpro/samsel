import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sammsel/auth/auth_service.dart';
import 'package:sammsel/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We wrap SamselApp in a Provider just like in main.dart to provide AuthService.
    await tester.pumpWidget(
      Provider<AuthService>(
        create: (_) => AuthService(),
        child: const SamselApp(),
      ),
    );

    // Verify that the Login Screen is shown by checking for the App Title.
    expect(find.text('SAMSEL'), findsOneWidget);
    expect(find.text('Publication Management System'), findsOneWidget);

    // Verify that the Login button is present.
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
