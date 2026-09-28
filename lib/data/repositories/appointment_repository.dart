import '../models/appointment.dart';

/// Kontrak sumber data janji temu pasien.
abstract class AppointmentRepository {
  Future<List<Appointment>> fetchByUser(int userId);

  Future<void> clear(int userId);
}
