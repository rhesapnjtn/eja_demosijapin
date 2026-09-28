import '../../core/utils/formatters.dart';

/// Data identitas pasien yang sudah dimasking aman ditampilkan.
///
/// Sumber kolom: tabel `m_customer` Sitanala. Kolom yang belum
/// terverifikasi terhadap skema resmi **tidak** dibuat di sini
/// (Aturan 3 AGENTS.md — Zero-Hallucination).
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.nik,
    this.phone,
    this.gender,
    this.bloodType,
    this.birthDate,
    this.address,
  });

  final int id;
  final String fullName;
  final String email;

  /// 16 digit. Wajib disensor sebelum tampil: [Fmt.nikMask].
  final String? nik;

  /// Wajib disensor sebelum tampil: [Fmt.phoneMask].
  final String? phone;

  /// `L` = Laki-laki, `P` = Perempuan.
  final String? gender;

  /// Golongan darah: A, B, AB, O.
  final String? bloodType;
  final DateTime? birthDate;
  final String? address;

  /// Dua huruf awal untuk avatar; dipakai bila foto tidak tersedia.
  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return _initialOf(parts.first);
    return '${_initialOf(parts.first)}${_initialOf(parts.last)}';
  }

  int? get age => Fmt.ageFrom(birthDate);

  /// NIK + tanggal lahir wajib terisi sebelum pendaftaran rawat jalan.
  bool get hasProfileComplete =>
      (nik != null && nik!.isNotEmpty) && birthDate != null;

  AppUser copyWith({
    int? id,
    String? fullName,
    String? email,
    String? nik,
    String? phone,
    String? gender,
    String? bloodType,
    DateTime? birthDate,
    String? address,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          other.id == id &&
          other.fullName == fullName &&
          other.email == email &&
          other.nik == nik &&
          other.phone == phone &&
          other.gender == gender &&
          other.bloodType == bloodType &&
          other.birthDate == birthDate &&
          other.address == address;

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    email,
    nik,
    phone,
    gender,
    bloodType,
    birthDate,
    address,
  );

  /// NIK disensor — Aturan 4 AGENTS.md melarang mencetak identitas
  /// kependudukan ke log konsol rilis.
  @override
  String toString() =>
      'AppUser(id: $id, fullName: $fullName, nik: ${Fmt.nikMask(nik)}, '
      'phone: ${Fmt.phoneMask(phone)})';
}

String _initialOf(String word) => word.substring(0, 1).toUpperCase();
