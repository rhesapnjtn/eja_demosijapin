import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/appointment.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/repositories/dummy_appointment_repository.dart';
import 'auth_provider.dart';

/// Sumber data janji temu. Di-override di test agar tidak menembak server.
final appointmentRepositoryProvider = Provider<AppointmentRepository>(
  (Ref ref) => DummyAppointmentRepository(),
);

final appointmentProvider =
    NotifierProvider<AppointmentNotifier, AppointmentState>(
      AppointmentNotifier.new,
    );

class AppointmentState {
  const AppointmentState({
    this.items = const <Appointment>[],
    this.isLoading = true,
    this.error,
  });

  final List<Appointment> items;
  final bool isLoading;
  final String? error;

  bool get isEmpty => items.isEmpty;

  /// Dipakai badge pada tab "Janji Temu".
  int get upcomingCount =>
      items.where((Appointment a) => a.isUpcoming).length;

  int get completedCount =>
      items.where((Appointment a) => a.status == AppointmentStatus.completed)
          .length;

  List<Appointment> get upcoming => items
      .where((Appointment a) => a.isUpcoming)
      .toList(growable: false);

  List<Appointment> get history => items
      .where((Appointment a) => !a.isUpcoming)
      .toList(growable: false);

  AppointmentState copyWith({
    List<Appointment>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AppointmentState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AppointmentNotifier extends Notifier<AppointmentState> {
  /// Pemuatan dipicu di sini, bukan di widget, supaya badge navbar dan
  /// kartu ringkasan profil selalu membaca sumber data yang sama.
  @override
  AppointmentState build() {
    final int? userId = ref.watch(
      authProvider.select((AuthState a) => a.user?.id),
    );
    if (userId == null) return const AppointmentState(isLoading: false);
    Future<void>.microtask(() => _load(userId));
    return const AppointmentState();
  }

  AppointmentRepository get _repo => ref.read(appointmentRepositoryProvider);

  Future<void> _load(int userId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final List<Appointment> items = await _repo.fetchByUser(userId);
      state = AppointmentState(items: items, isLoading: false);
    } on Object catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat: $e');
    }
  }

  /// Muat ulang manual, dipakai tombol "Coba Lagi".
  Future<void> load(int userId) => _load(userId);

  void clear() => state = const AppointmentState(isLoading: false);
}
