import '../models/appointment.dart';
import 'appointment_repository.dart';

/// Implementasi [AppointmentRepository] dengan data tiruan.
///
/// DATA INI FIKTIF dan hanya untuk slicing UI. Nama dokter, poliklinik,
/// dan kode booking di bawah tidak berasal dari database SIMRS.
class DummyAppointmentRepository implements AppointmentRepository {
  DummyAppointmentRepository({this.latency = const Duration(milliseconds: 350)});

  final Duration latency;

  final Map<int, List<Appointment>> _store = <int, List<Appointment>>{};

  @override
  Future<List<Appointment>> fetchByUser(int userId) async {
    await Future<void>.delayed(latency);
    return List<Appointment>.unmodifiable(
      _store.putIfAbsent(userId, () => _seed()).toList()
        ..sort((Appointment a, Appointment b) => a.date.compareTo(b.date)),
    );
  }

  @override
  Future<void> clear(int userId) async {
    await Future<void>.delayed(latency);
    _store.remove(userId);
  }

  /// Baris tiruan: 1 selesai, 1 akan datang, 1 dibatalkan.
  List<Appointment> _seed() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return <Appointment>[
      Appointment(
        id: 5001,
        bookingCode: _code(today.subtract(const Duration(days: 21)), 1),
        polyName: 'Poli Penyakit Dalam',
        doctorName: 'dr. Contoh Sitorus',
        date: today.subtract(const Duration(days: 21)),
        status: AppointmentStatus.completed,
        queueNumber: 12,
      ),
      Appointment(
        id: 5002,
        bookingCode: _code(today.add(const Duration(days: 3)), 7),
        polyName: 'Poli Gigi',
        doctorName: 'dr. Contoh Wijaya',
        date: today.add(const Duration(days: 3)),
        status: AppointmentStatus.upcoming,
        queueNumber: 4,
      ),
      Appointment(
        id: 5003,
        bookingCode: _code(today.subtract(const Duration(days: 5)), 3),
        polyName: 'Poli Kandungan',
        doctorName: 'dr. Contoh Sitorus',
        date: today.subtract(const Duration(days: 5)),
        status: AppointmentStatus.cancelled,
      ),
    ];
  }

  /// Aturan 5 AGENTS.md: `YYYYMMDD` + counter 5 digit = 13 digit.
  String _code(DateTime date, int counter) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y$m$d${counter.toString().padLeft(5, '0')}';
  }
}
