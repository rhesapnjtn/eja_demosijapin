/// Validator input form.
///
/// Semua aturan di sini adalah aturan UI/klien; validasi akhir tetap
/// dilakukan ulang di sisi server CI3.
class V {
  const V._();

  static const int minNameLength = 3;
  static const int nikLength = 16;
  static const int minPhoneLength = 9;
  static const int maxPhoneLength = 15;
  static const int minPasswordLength = 6;

  static String? required_(String? value, {String field = 'Kolom ini'}) {
    if (value == null || value.trim().isEmpty) return '$field wajib diisi';
    return null;
  }

  static String? name(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Nama lengkap wajib diisi';
    if (v.length < minNameLength) {
      return 'Nama minimal $minNameLength karakter';
    }
    if (!RegExp(r"^[a-zA-Z\s'.,-]+$").hasMatch(v)) {
      return 'Nama hanya boleh huruf, spasi, dan tanda baca sederhana';
    }
    return null;
  }

  /// Nomor HP Indonesia: 9–15 digit, diawali 62 atau 08.
  static String? phone(String? value) {
    final String v = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (v.isEmpty) return null;
    if (v.length < minPhoneLength || v.length > maxPhoneLength) {
      return 'Nomor HP tidak valid';
    }
    if (!v.startsWith('62') && !v.startsWith('08')) {
      return 'Nomor HP diawali 62 atau 08';
    }
    return null;
  }

  /// NIK 16 digit numerik murni.
  static String? nik(String? value) {
    final String v = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (v.isEmpty) return null;
    if (v.length != nikLength) return 'NIK harus $nikLength digit';
    return null;
  }

  static String? password(String? value) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Kata sandi wajib diisi';
    if (v.length < minPasswordLength) {
      return 'Kata sandi minimal $minPasswordLength karakter';
    }
    return null;
  }
}
