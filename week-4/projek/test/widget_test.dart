import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projek/main.dart';
import 'package:projek/widgets/app_button.dart';

void main() {
  testWidgets('ProfilePage renders identity and GitHub button correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Personal Profile Card'), findsOneWidget);
    expect(find.text('Muhammad Amizola Rahmandani'), findsOneWidget);
    expect(find.text('20240801083'), findsOneWidget);
    expect(find.text('Teknik Informatika'), findsOneWidget);
    expect(
      find.text('Mahasiswa yang tertarik dengan web development pada ui/ux dan frontend'),
      findsOneWidget,
    );
    expect(find.text('Kunjungi GitHub Saya'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('AppButton renders label, icon, and calls onPressed', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Kunjungi GitHub',
            icon: Icons.code,
            url: 'https://github.com/Mizola21',
            height: 43,
            borderRadius: 7,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Kunjungi GitHub'), findsOneWidget);
    expect(find.byIcon(Icons.code), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(pressed, isTrue);
  });
}
