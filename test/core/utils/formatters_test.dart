import 'package:flutter_test/flutter_test.dart';
import 'package:sijapin_mobile/core/utils/formatters.dart';

void main() {
  group('Fmt masking identitas (UU PDP No. 27/2022)', () {
    test('nikMask menyensor 6 digit tengah', () {
      expect(Fmt.nikMask('3671041234560002'), '367104******0002');
    });

    test('bpjsMask menyensor 4 digit tengah', () {
      expect(Fmt.bpjsMask('000123456789'), '000123****789');
    });

    test('phoneMask menyensor 4 digit tengah', () {
      expect(Fmt.phoneMask('081298765432'), '0812****5432');
    });

    test('masking membuang karakter non-digit', () {
      expect(Fmt.nikMask('3671 04 1234 56 0002'), '367104******0002');
    });

    test('nilai kosong menghasilkan placeholder', () {
      expect(Fmt.nikMask(null), Fmt.empty);
      expect(Fmt.nikMask(''), Fmt.empty);
    });

    test('kode booking hanya menampilkan 8 digit awal', () {
      expect(Fmt.bookingCodeMask('2026030500012'), '20260305*****');
    });
  });

  group('Fmt label & tanggal', () {
    test('genderLabel memetakan L dan P', () {
      expect(Fmt.genderLabel('L'), 'Laki-laki');
      expect(Fmt.genderLabel('P'), 'Perempuan');
      expect(Fmt.genderLabel(null), Fmt.empty);
    });

    test('dateSlash memakai format dd/MM/yyyy', () {
      expect(Fmt.dateSlash(DateTime(2026, 3, 5)), '05/03/2026');
      expect(Fmt.dateSlash(null), Fmt.empty);
    });

    test('dateWithDay memakai nama hari Bahasa Indonesia', () {
      expect(Fmt.dateWithDay(DateTime(2026, 3, 5)), 'Kam, 5 Mar 2026');
    });

    test('ageFrom menghitung tahun lengkap', () {
      expect(
        Fmt.ageFrom(DateTime(1992, 4, 17), now: DateTime(2026, 4, 17)),
        34,
      );
      expect(
        Fmt.ageFrom(DateTime(1992, 4, 18), now: DateTime(2026, 4, 17)),
        33,
      );
      expect(Fmt.ageFrom(null), isNull);
    });

    test('rupiah memakai pemisah ribuan titik', () {
      expect(Fmt.rupiah(50000), 'Rp 50.000');
      expect(Fmt.rupiah(1200000), 'Rp 1.200.000');
    });
  });
}
