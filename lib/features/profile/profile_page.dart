import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/states.dart';
import '../../data/models/app_user.dart';
import '../../state/appointment_provider.dart';
import '../../state/auth_provider.dart';
import 'about_page.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState auth = ref.watch(authProvider);
    final AppointmentState appointments = ref.watch(appointmentProvider);
    final AppUser? user = auth.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Saya')),
        body: auth.isLoading
            ? const LoadingView()
            : ErrorView(
                message: auth.error ??
                    'Anda belum masuk. Silakan masuk untuk melihat profil.',
                onRetry: () => ref.read(authProvider.notifier).reload(),
              ),
      );
    }

    final int total = appointments.items.length;
    final int selesai = appointments.completedCount;
    final int akanDatang = appointments.upcomingCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.sm,
          AppSpacing.screenH,
          AppSpacing.xxxl,
        ),
        children: <Widget>[
          AppCard(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    UserAvatar(name: user.fullName, size: 62),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: <Widget>[
                              SoftChip(
                                label: Fmt.genderLabel(user.gender),
                                icon: user.gender == 'P'
                                    ? Icons.female_rounded
                                    : Icons.male_rounded,
                                dense: true,
                              ),
                              SoftChip(
                                label: Fmt.bloodTypeLabel(user.bloodType) ==
                                        Fmt.empty
                                    ? 'Gol. darah -'
                                    : 'Gol. darah '
                                          '${Fmt.bloodTypeLabel(user.bloodType)}',
                                icon: Icons.bloodtype_outlined,
                                color: AppColors.danger,
                                dense: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!user.hasProfileComplete) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: AppSpacing.cardTight,
                    decoration: const BoxDecoration(
                      color: AppColors.warningContainer,
                      borderRadius: AppRadius.fieldRadius,
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.info_rounded,
                          size: 18,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Lengkapi data NIK dan tanggal lahir untuk '
                            'mempercepat layanan.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF6B4608)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    _Stat(
                      label: 'Janji temu',
                      value: '$total',
                      icon: Icons.event_note_rounded,
                      color: AppColors.goldenCaramel,
                    ),
                    _Stat(
                      label: 'Akan datang',
                      value: '$akanDatang',
                      icon: Icons.schedule_rounded,
                      color: AppColors.clinicalTeal,
                    ),
                    _Stat(
                      label: 'Selesai',
                      value: '$selesai',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _IdentityCard(user: user),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: <Widget>[
                _MenuTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profil',
                  subtitle: 'Nama, NIK, alamat, dan data kesehatan',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EditProfilePage(),
                    ),
                  ),
                ),
                const Divider(),
                _MenuTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Ganti Kata Sandi',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ChangePasswordPage(),
                    ),
                  ),
                ),
                const Divider(),
                _MenuTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Pengingat Janji Temu',
                  subtitle: 'Diaktifkan',
                  trailing: Switch(
                    value: true,
                    onChanged: (bool v) => AppSnack.show(
                      context,
                      v
                          ? 'Pengingat aktif 1 hari sebelum jadwal.'
                          : 'Pengingat dimatikan.',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: <Widget>[
                _MenuTile(
                  icon: Icons.info_outline_rounded,
                  label: 'Tentang ${AppConfig.appName}',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const AboutPage()),
                  ),
                ),
                const Divider(),
                _MenuTile(
                  icon: Icons.delete_outline_rounded,
                  label: 'Hapus Akun',
                  subtitle: 'Menghapus seluruh data di perangkat ini',
                  color: AppColors.danger,
                  onTap: () => _confirmDelete(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  '${AppConfig.appName} versi ${AppConfig.appVersion}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'RSUP Dr. Sitanala Tangerang • Kemenkes RI',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Keluar dari aplikasi?'),
        content: Text(
          'Anda perlu masuk kembali untuk melihat janji temu Anda.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              minimumSize: const Size(110, 44),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(authProvider.notifier).logout();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Hapus akun permanen?'),
        content: Text(
          'Seluruh data profil, janji temu, dan ulasan Anda akan dihapus '
          'dari perangkat ini dan tidak dapat dikembalikan.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(120, 44),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authProvider.notifier).deleteAccount();
      if (context.mounted) {
        AppSnack.show(context, 'Akun telah dihapus', success: true);
      }
    }
  }
}

/// Ringkasan identitas. NIK dan nomor HP disensor (Aturan 4 AGENTS.md).
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Data identitas', style: t.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _IdentityRow(label: 'NIK', value: Fmt.nikMask(user.nik)),
          _IdentityRow(label: 'Nomor HP', value: Fmt.phoneMask(user.phone)),
          _IdentityRow(label: 'Tanggal lahir', value: Fmt.dateSlash(user.birthDate)),
          _IdentityRow(
            label: 'Usia',
            value: user.age == null ? Fmt.empty : '${user.age} tahun',
          ),
          _IdentityRow(label: 'Alamat', value: user.address ?? Fmt.empty),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 108, child: Text(label, style: t.bodySmall)),
          Expanded(
            child: Text(
              value,
              style: t.titleSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 19, fontWeight: w800, color: color),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color c = color ?? AppColors.textPrimary;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.10),
          borderRadius: AppRadius.fieldRadius,
        ),
        child: Icon(icon, size: 19, color: c),
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 14.5, fontWeight: w600, color: c),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing:
          trailing ??
          Icon(Icons.chevron_right_rounded, color: c.withValues(alpha: 0.4)),
    );
  }
}
