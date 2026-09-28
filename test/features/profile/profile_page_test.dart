import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijapin_mobile/core/theme/app_theme.dart';
import 'package:sijapin_mobile/core/utils/formatters.dart';
import 'package:sijapin_mobile/data/models/appointment.dart';
import 'package:sijapin_mobile/data/models/app_user.dart';
import 'package:sijapin_mobile/data/repositories/appointment_repository.dart';
import 'package:sijapin_mobile/data/repositories/auth_repository.dart';
import 'package:sijapin_mobile/features/profile/profile_page.dart';
import 'package:sijapin_mobile/state/appointment_provider.dart';
import 'package:sijapin_mobile/state/auth_provider.dart';

const AppUser _user = AppUser(
  id: 7,
  fullName: 'Ahmad Dhani Setiawan',
  email: 'contoh@id',
  nik: '3671041234560002',
  phone: '081298765432',
  gender: 'L',
  bloodType: 'O',
  birthDate: null,
);

class _Auth implements AuthRepository {
  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<AppUser> updateProfile(AppUser value) async => value;

  @override
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<void> deleteAccount() async {}
}

class _Appointments implements AppointmentRepository {
  @override
  Future<List<Appointment>> fetchByUser(int userId) async {
    final DateTime now = DateTime.now();
    return <Appointment>[
      Appointment(
        id: 1,
        bookingCode: '2026030500001',
        polyName: 'Poli Penyakit Dalam',
        doctorName: 'dr. Contoh',
        date: now.add(const Duration(days: 2)),
        status: AppointmentStatus.upcoming,
      ),
      Appointment(
        id: 2,
        bookingCode: '2026021300002',
        polyName: 'Poli Gigi',
        doctorName: 'dr. Contoh',
        date: now.subtract(const Duration(days: 5)),
        status: AppointmentStatus.completed,
      ),
    ];
  }

  @override
  Future<void> clear(int userId) async {}
}

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(_Auth()),
      appointmentRepositoryProvider.overrideWithValue(_Appointments()),
    ],
    child: MaterialApp(theme: AppTheme.light, home: child),
  );
}

Future<void> _pumpProfile(WidgetTester tester) async {
  await tester.pumpWidget(_wrap(const ProfilePage()));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('menampilkan identitas dasar pasien', (
    WidgetTester tester,
  ) async {
    await _pumpProfile(tester);

    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Ahmad Dhani Setiawan'), findsWidgets);
    expect(find.text('Laki-laki'), findsOneWidget);
    expect(find.text('Gol. darah O'), findsOneWidget);
  });

  testWidgets('menyensor NIK dan nomor HP di layar', (
    WidgetTester tester,
  ) async {
    await _pumpProfile(tester);

    expect(find.text('367104******0002'), findsOneWidget);
    expect(find.text('0812****5432'), findsOneWidget);
    expect(find.textContaining('3671041234560002'), findsNothing);
    expect(find.textContaining('081298765432'), findsNothing);
  });

  testWidgets('menampilkan statistik janji temu dari repository', (
    WidgetTester tester,
  ) async {
    await _pumpProfile(tester);

    // 1 akan datang + 1 selesai = 2 janji temu.
    expect(find.text('2'), findsNWidgets(1));
    expect(find.text('1'), findsNWidgets(2));
  });

  testWidgets('menu Edit Profil dan Tentang dapat dibuka', (
    WidgetTester tester,
  ) async {
    await _pumpProfile(tester);

    await tester.ensureVisible(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Edit Profil'), findsOneWidget);
    expect(find.text('Golongan darah'), findsOneWidget);
    Navigator.of(tester.element(find.byType(AppBar))).pop();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.textContaining('Tentang'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Tentang'));
    await tester.pumpAndSettle();
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });

  testWidgets('peringatan profil belum lengkap tampil saat NIK kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_NoNikAuth()),
          appointmentRepositoryProvider.overrideWithValue(_Appointments()),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.textContaining('Lengkapi data NIK'), findsOneWidget);
    // NIK kosong disensor menjadi placeholder, tidak pernah tampil utuh.
    expect(find.text(Fmt.nikMask(null)), findsWidgets);
    expect(find.textContaining('0000'), findsNothing);
  });
}

class _NoNikAuth implements AuthRepository {
  @override
  Future<AppUser?> currentUser() async => const AppUser(
    id: 9,
    fullName: 'Tanpa NIK',
    email: 'tanpa@id',
  );

  @override
  Future<AppUser> updateProfile(AppUser value) async => value;

  @override
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<void> deleteAccount() async {}
}
