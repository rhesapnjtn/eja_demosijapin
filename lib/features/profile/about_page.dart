import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/common.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.lg,
          AppSpacing.screenH,
          AppSpacing.xxxl,
        ),
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                const AppLogo(size: 82),
                const SizedBox(height: AppSpacing.lg),
                const AppWordmark(size: 26),
                const SizedBox(height: AppSpacing.xs),
                Text('Versi ${AppConfig.appVersion}', style: t.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tentang aplikasi', style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'SIIJAPIN Mobile adalah aplikasi layanan '
                  'RSUP Dr. Sitanala Tangerang untuk memudahkan pasien '
                  'mencari dokter, memesan jadwal, dan mengelola janji temu '
                  'secara mandiri. Aplikasi ini adalah klien resmi rumah '
                  'sakit yang berjalan di atas sistem SIMRS yang sudah ada.',
                  style: t.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Fitur saat ini', style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                const _Feature(
                  icon: Icons.event_note_rounded,
                  text: 'Janji temu rawat jalan poliklinik',
                ),
                const _Feature(
                  icon: Icons.confirmation_number_rounded,
                  text: 'Kode booking 13 digit & nomor antrean digital',
                ),
                const _Feature(
                  icon: Icons.person_rounded,
                  text: 'Kelola data identitas pasien',
                ),
                const _Feature(
                  icon: Icons.calendar_month_rounded,
                  text: 'Kalender kunjungan dan pengingat',
                ),
                const _Feature(
                  icon: Icons.qr_code_2_rounded,
                  text: 'Tiket QR untuk mesin APM di lobi',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Profil rumah sakit', style: t.titleSmall),
                const Divider(height: AppSpacing.xl),
                const InfoRow(
                  icon: Icons.local_hospital_rounded,
                  label: 'Nama rumah sakit',
                  value: 'RSUP Dr. Sitanala Tangerang',
                ),
                const InfoRow(
                  icon: Icons.account_balance_rounded,
                  label: 'Instansi',
                  value: 'Kementerian Kesehatan Republik Indonesia',
                ),
                const InfoRow(
                  icon: Icons.language_rounded,
                  label: 'Situs resmi',
                  value: AppConfig.baseUrl,
                ),
                const InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Catatan',
                  value:
                      'Alamat, telepon, dan surel unit resmi akan '
                      'diisi dari kontrak API rumah sakit.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Fitur yang sudah final dan lulus uji dicatat pada '
            'DONE.md repositori proyek.',
            textAlign: TextAlign.center,
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.goldenCaramel),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
