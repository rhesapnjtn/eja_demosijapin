import 'package:flutter/material.dart';

import '../../core/widgets/coming_soon_view.dart';

/// Riwayat & daftar janji temu. Badge pada tab navigasi sudah aktif
/// dan menghitung janji temu yang akan datang.
class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      icon: Icons.event_note_rounded,
      title: 'Janji Temu',
      description:
          'Daftar janji temu yang akan datang, riwayat kunjungan, dan '
          'tiket QR untuk mesin APM akan ditambahkan setelah alur '
          'pendaftaran rawat jalan selesai.',
    );
  }
}
