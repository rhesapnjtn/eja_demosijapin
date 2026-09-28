import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/app_user.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/dummy_auth_repository.dart';
import 'appointment_provider.dart';

/// Sumber data auth. Di-override di test agar tidak menembak server.
final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => DummyAuthRepository(),
);

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Keadaan sesi pasien: siapa yang login, masih memuat, atau gagal.
class AuthState {
  const AuthState({this.user, this.isLoading = true, this.isSaving = false, this.error});

  final AppUser? user;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future<void>.microtask(_load);
    return const AuthState();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final AppUser? user = await _repo.currentUser();
      state = AuthState(user: user, isLoading: false);
    } on Object catch (e) {
      state = AuthState(isLoading: false, error: 'Gagal memuat profil: $e');
    }
  }

  /// Dipanggil ulang dari UI saat ingin mencoba kembali.
  Future<void> reload() => _load();

  Future<bool> updateProfile(AppUser user) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final AppUser updated = await _repo.updateProfile(user);
      state = state.copyWith(user: updated, isSaving: false);
      return true;
    } on Object catch (e) {
      state = state.copyWith(isSaving: false, error: 'Gagal menyimpan: $e');
      return false;
    }
  }

  /// Mengembalikan pesan error, atau `null` bila berhasil.
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final String? error = await _repo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    state = state.copyWith(isSaving: false);
    return error;
  }

  Future<void> logout() async {
    await _repo.logout();
    ref.read(appointmentProvider.notifier).clear();
    state = const AuthState(user: null, isLoading: false);
  }

  Future<void> deleteAccount() async {
    await _repo.deleteAccount();
    ref.read(appointmentProvider.notifier).clear();
    state = const AuthState(user: null, isLoading: false);
  }
}
