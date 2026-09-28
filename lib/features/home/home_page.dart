import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_logo.dart';
import '../../state/auth_provider.dart';
import '../shell/main_shell.dart';

/// Beranda. Saat ini menampilkan sapaan, pintasan tab, dan pengingat
/// bahwa kartu tiket hari-H & daftar poli masih dalam pengerjaan.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState auth = ref.watch(authProvider);
    final TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.lg,
            AppSpacing.screenH,
            AppSpacing.xxxl,
          ),
          children: <Widget>[
            Row(
              children: <Widget>[
                const AppLogo(size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        auth.isLoading ? 'Memuat…' : _salam(auth.user?.fullName),
                        style: t.titleSmall,
                      ),
                      const SizedBox(height: 1),
                      Text(AppConfig.appName, style: t.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Selamat datang', style: t.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Kelola janji temu rawat jalan Anda di RSUP Dr. Sitanala '
              'Tangerang langsung dari satu aplikasi.',
              style: t.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                Expanded(
                  child: _Shortcut(
                    icon: Icons.search_rounded,
                    label: 'Cari Dokter',
                    onTap: () => ShellScope.of(context).goToTab(1),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _Shortcut(
                    icon: Icons.event_note_rounded,
                    label: 'Janji Temu',
                    onTap: () => ShellScope.of(context).goToTab(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _Shortcut(
                    icon: Icons.person_rounded,
                    label: 'Profil',
                    onTap: () => ShellScope.of(context).goToTab(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const _RoadmapCard(),
          ],
        ),
      ),
    );
  }

  static String _salam(String? name) {
    final String first = (name ?? '').trim().split(RegExp(r'\s+')).first;
    if (first.isEmpty) return 'Halo';
    return 'Halo, ${first.substring(0, 1).toUpperCase()}${first.substring(1)}';
  }
}

class _RoadmapCard extends StatelessWidget {
  const _RoadmapCard();

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.softSand),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.construction_rounded,
            size: 20,
            color: AppColors.deepChocolate,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Halaman beranda belum final', style: t.titleSmall),
                const SizedBox(height: 2),
                Text(
                  'Kartu tiket hari-H dan daftar poli akan ditambahkan '
                  'berikutnya.',
                  style: t.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outline),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              children: <Widget>[
                Icon(icon, size: 22, color: AppColors.goldenCaramel),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
