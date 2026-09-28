import '../models/app_user.dart';

/// Kontrak sumber data profil pasien.
///
/// Implementasi produksi (CI3 + cookie sesi) menyusul; yang dipakai
/// sekarang adalah [DummyAuthRepository] pada fase slicing UI.
abstract class AuthRepository {
  /// Pasien yang sedang login, atau `null` bila belum masuk.
  Future<AppUser?> currentUser();

  Future<AppUser> updateProfile(AppUser user);

  /// Mengembalikan pesan error, atau `null` bila berhasil.
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<void> logout();

  /// Menghapus seluruh data lokal pasien di perangkat ini.
  Future<void> deleteAccount();
}
