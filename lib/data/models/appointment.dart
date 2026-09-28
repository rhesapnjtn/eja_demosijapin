/// Status janji temu. Nilai `wire` harus sama dengan string yang
/// dikirim server CI3.
enum AppointmentStatus {
  completed('completed'),
  upcoming('upcoming'),
  cancelled('cancelled');

  const AppointmentStatus(this.wire);

  final String wire;

  static AppointmentStatus fromWire(String? value) => switch (value) {
    'completed' => AppointmentStatus.completed,
    'cancelled' => AppointmentStatus.cancelled,
    _ => AppointmentStatus.upcoming,
  };
}

/// Satu baris janji temu pasien di Poliklinik.
///
/// Aturan 5 AGENTS.md: [bookingCode] wajib 13 digit numerik murni
/// (`YYYYMMDD` + counter 5 digit) dan tidak boleh disisipi prefix teks.
class Appointment {
  const Appointment({
    required this.id,
    required this.bookingCode,
    required this.polyName,
    required this.doctorName,
    required this.date,
    required this.status,
    this.queueNumber,
  });

  final int id;

  /// 13 digit: `YYYYMMDD` + counter 5 digit.
  final String bookingCode;
  final String polyName;
  final String doctorName;
  final DateTime date;
  final AppointmentStatus status;
  final int? queueNumber;

  bool get isUpcoming =>
      status == AppointmentStatus.upcoming && !date.isBefore(_today());

  bool get isPast =>
      status == AppointmentStatus.upcoming && date.isBefore(_today());

  static DateTime _today() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
