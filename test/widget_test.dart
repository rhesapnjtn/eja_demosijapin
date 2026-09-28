import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijapin_mobile/main.dart';

/// Repository tiruan memakai `Future.delayed`, jadi perlu satu pompaan
/// tambahan agar tidak ada timer yang tertinggal saat test selesai.
Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('SiijapinApp membuka MainShell dengan navbar bawah', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SiijapinApp()));
    await _settle(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Beranda'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tab Profil dapat diakses dari navbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SiijapinApp()));
    await _settle(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profil Saya'), findsOneWidget);
  });
}
