import 'package:flutter/material.dart';

import '../../core/widgets/coming_soon_view.dart';

/// Daftar dokter & poliklinik. Menunggu kontrak endpoint CI3
/// (`m_pegawai` + jadwal praktik) sebelum diisi.
class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      icon: Icons.search_rounded,
      title: 'Cari Dokter',
      description:
          'Pencarian dokter, filter poliklinik, dan jadwal praktik akan '
          'tersambung ke data SIMRS Sitanala.',
    );
  }
}
