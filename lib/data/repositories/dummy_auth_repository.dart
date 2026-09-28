import '../models/app_user.dart';
import 'auth_repository.dart';

/// Implementasi [AuthRepository] dengan data tiruan.
///
/// DATA INI FIKTIF dan hanya untuk slicing UI. Wajib diganti oleh
/// implementasi CI3 sebelum fitur dicatat FINAL di `DONE.md`
/// (Aturan 4 & 6 AGENTS.md). Tidak ada kredensial yang disimpan.
class DummyAuthRepository implements AuthRepository {
  DummyAuthRepository({this.latency = const Duration(milliseconds: 350)});

  final Duration latency;

  AppUser? _user = AppUser(
    id: 1001,
    fullName: 'Ahmad Dhani Setiawan',
    email: 'ahmad.dhani@contoh.id',
    nik: '3671041234560002',
    phone: '081298765432',
    gender: 'L',
    bloodType: 'O',
    birthDate: DateTime(1992, 4, 17),
    address: 'Kota Tangerang, Provinsi Banten',
  );

  @override
  Future<AppUser?> currentUser() async {
    await Future<void>.delayed(latency);
    return _user;
  }

  @override
  Future<AppUser> updateProfile(AppUser user) async {
    await Future<void>.delayed(latency);
    _user = user;
    return user;
  }

  @override
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await Future<void>.delayed(latency);
    if (oldPassword.isEmpty) return 'Kata sandi lama wajib diisi';
    if (newPassword.length < 6) return 'Kata sandi baru minimal 6 karakter';
    if (newPassword != confirmPassword) {
      return 'Konfirmasi kata sandi tidak sama';
    }
    if (newPassword == oldPassword) {
      return 'Kata sandi baru harus berbeda dari yang lama';
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(latency);
    _user = null;
  }

  @override
  Future<void> deleteAccount() async {
    await Future<void>.delayed(latency);
    _user = null;
  }
}
