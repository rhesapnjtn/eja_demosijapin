import 'package:flutter_test/flutter_test.dart';
import 'package:sijapin_mobile/core/utils/formatters.dart';
import 'package:sijapin_mobile/data/models/app_user.dart';

void main() {
  group('AppUser', () {
    const AppUser user = AppUser(
      id: 1,
      fullName: 'Ahmad Dhani Setiawan',
      email: 'contoh@id',
      nik: '3671041234560002',
    );

    test('initials mengambil huruf awal nama depan dan belakang', () {
      expect(user.initials, 'AS');
    });

    test('initials untuk nama tunggal', () {
      expect(
        const AppUser(id: 2, fullName: 'Rina', email: 'a@b.c').initials,
        'R',
      );
    });

    test('initials untuk nama kosong', () {
      expect(const AppUser(id: 3, fullName: '  ', email: 'a@b.c').initials, '?');
    });

    test('hasProfileComplete exige NIK dan tanggal lahir', () {
      expect(user.hasProfileComplete, isFalse);
      expect(
        user.copyWith(birthDate: DateTime(1992, 4, 17)).hasProfileComplete,
        isTrue,
      );
    });

    test('toString tidak membocorkan NIK utuh', () {
      expect(user.toString(), isNot(contains('3671041234560002')));
      expect(user.toString(), contains(Fmt.nikMask('3671041234560002')));
    });
  });
}
