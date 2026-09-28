/// Utilitas pemformatan nilai & **penyensor data identitas**.
///
/// Aturan 4 AGENTS.md (UU PDP No. 27/2022): NIK, nomor kartu BPJS,
/// dan nomor HP tidak boleh ditampilkan utuh di layar maupun log.
class Fmt {
  const Fmt._();

  static const String empty = '-';

  static const List<String> _dayShort = <String>[
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  static const List<String> _dayLong = <String>[
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _monthShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static const List<String> _monthLong = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const String _male = 'L';
  static const String _female = 'P';

  /// Kode gender kolom `jk` pada tabel Pasien Sitanala.
  static String genderLabel(String? gender) => switch (gender) {
    _male => 'Laki-laki',
    _female => 'Perempuan',
    _ => empty,
  };

  static String bloodTypeLabel(String? bloodType) {
    final String v = (bloodType ?? '').trim();
    return v.isEmpty ? empty : v.toUpperCase();
  }

  /// Buang semua karakter selain digit.
  static String digitsOnly(String? value) {
    if (value == null) return '';
    return value.replaceAll(RegExp(r'\D'), '');
  }

  /// NIK 16 digit: 6 digit awal + 6 tersensor + 4 digit akhir.
  static String nikMask(String? nik) =>
      _mask(nik, head: 6, tail: 4, stars: 6);

  /// No. Kartu BPJS: 6 digit awal + 4 tersensor + 3 digit akhir.
  static String bpjsMask(String? bpjs) =>
      _mask(bpjs, head: 6, tail: 3, stars: 4);

  /// No. HP: 4 digit awal + 4 tersensor + 4 digit akhir.
  static String phoneMask(String? phone) =>
      _mask(phone, head: 4, tail: 4, stars: 4);

  /// Aturan 5 AGENTS.md: kode booking 13 digit numerik murni.
  static String bookingCodeMask(String? code) {
    final String v = digitsOnly(code);
    if (v.length <= 8) return v.isEmpty ? empty : v;
    return '${v.substring(0, 8)}*****';
  }

  static String _mask(
    String? value, {
    required int head,
    required int tail,
    required int stars,
  }) {
    final String v = digitsOnly(value);
    if (v.isEmpty) return empty;
    if (v.length <= head + tail) return v;
    return '${v.substring(0, head)}${'*' * stars}${v.substring(v.length - tail)}';
  }

  static String two(int value) => value.toString().padLeft(2, '0');

  /// `05/03/2026`
  static String dateSlash(DateTime? value) {
    if (value == null) return empty;
    return '${two(value.day)}/${two(value.month)}/${value.year}';
  }

  /// `Sen, 5 Mar 2026`
  static String dateWithDay(DateTime? value) {
    if (value == null) return empty;
    return '${_dayShort[value.weekday - 1]}, ${value.day} '
        '${_monthShort[value.month - 1]} ${value.year}';
  }

  /// `Senin, 5 Maret 2026`
  static String dateLong(DateTime? value) {
    if (value == null) return empty;
    return '${_dayLong[value.weekday - 1]}, ${value.day} '
        '${_monthLong[value.month - 1]} ${value.year}';
  }

  /// `5 Maret 2026, 09:30`
  static String dateTimeLong(DateTime? value) {
    if (value == null) return empty;
    return '${dateLong(value)}, ${two(value.hour)}.${two(value.minute)}';
  }

  /// Umur patients dalam tahun lengkap.
  static int? ageFrom(DateTime? birthDate, {DateTime? now}) {
    if (birthDate == null) return null;
    final DateTime today = now ?? DateTime.now();
    if (birthDate.isAfter(today)) return null;
    int years = today.year - birthDate.year;
    final bool birthdayPassed =
        today.month > birthDate.month ||
        (today.month == birthDate.month && today.day >= birthDate.day);
    if (!birthdayPassed) years -= 1;
    return years;
  }

  /// `Rp 50.000`
  static String rupiah(num? value) {
    if (value == null) return empty;
    final String digits = value.round().abs().toString();
    final StringBuffer out = StringBuffer('Rp ');
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write('.');
      out.write(digits[i]);
    }
    return value < 0 ? '-$out' : out.toString();
  }
}
