import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijapin_mobile/core/theme/app_theme.dart';
import 'package:sijapin_mobile/data/models/appointment.dart';
import 'package:sijapin_mobile/data/models/app_user.dart';
import 'package:sijapin_mobile/data/repositories/appointment_repository.dart';
import 'package:sijapin_mobile/data/repositories/auth_repository.dart';
import 'package:sijapin_mobile/features/shell/main_shell.dart';
import 'package:sijapin_mobile/state/appointment_provider.dart';
import 'package:sijapin_mobile/state/auth_provider.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.user);

  final AppUser? user;
  int logoutCount = 0;
  int deleteCount = 0;

  @override
  Future<AppUser?> currentUser() async => user;

  @override
  Future<AppUser> updateProfile(AppUser value) async => value;

  @override
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async => null;

  @override
  Future<void> logout() async => logoutCount++;

  @override
  Future<void> deleteAccount() async => deleteCount++;
}

class _EmptyAppointmentRepository implements AppointmentRepository {
  @override
  Future<List<Appointment>> fetchByUser(int userId) async =>
      const <Appointment>[];

  @override
  Future<void> clear(int userId) async {}
}

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        _FakeAuthRepository(
          const AppUser(
            id: 7,
            fullName: 'Ahmad Dhani Setiawan',
            email: 'contoh@id',
          ),
        ),
      ),
      appointmentRepositoryProvider.overrideWithValue(
        _EmptyAppointmentRepository(),
      ),
    ],
    child: MaterialApp(theme: AppTheme.light, home: child),
  );
}

void main() {
  /// Label navbar harus dicari di dalam [NavigationBar] saja, karena
  /// [IndexedStack] ikut membangun halaman yang tidak sedang aktif.
  Finder navLabel(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  testWidgets('MainShell menampilkan lima tujuan navigasi bawah', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const MainShell()));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    for (final String label in <String>[
      'Beranda',
      'Cari Dokter',
      'Janji Temu',
      'Artikel',
      'Profil',
    ]) {
      expect(navLabel(label), findsOneWidget, reason: 'label $label');
    }
  });

  testWidgets('tab Profil terbuka lewat navbar dan menampilkan nama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(navLabel('Profil'));
    await tester.pumpAndSettle();

    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Ahmad Dhani Setiawan'), findsWidgets);
    expect(find.text('contoh@id'), findsOneWidget);
  });

  testWidgets('tab lain dapat dipilih dan kembali ke Beranda', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const MainShell()));
    await tester.pumpAndSettle();

    await tester.tap(navLabel('Cari Dokter'));
    await tester.pumpAndSettle();
    expect(find.text('Fitur sedang disiapkan'), findsOneWidget);

    await tester.tap(navLabel('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang'), findsOneWidget);
  });

  testWidgets('initialIndex membuka tab yang diminta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const MainShell(initialIndex: 2)));
    await tester.pumpAndSettle();

    expect(find.text('Fitur sedang disiapkan'), findsOneWidget);
  });
}
