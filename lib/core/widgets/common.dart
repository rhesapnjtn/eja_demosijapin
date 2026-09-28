import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Avatar inisial pasien. Foto profil diambil dari storage lokal,
/// sehingga bila `imagePath` kosong tampil inisial nama.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.size = 48, this.imagePath});

  final String name;
  final double size;
  final String? imagePath;

  static String initialsOf(String fullName) {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();  }

  @override
  Widget build(BuildContext context) {
    final String? path = imagePath;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(size / 2.8),
        border: Border.all(color: AppColors.softSand),
      ),
      child: path == null || path.isEmpty
          ? Center(
              child: Text(
                initialsOf(name),
                style: TextStyle(
                  fontSize: size * 0.36,
                  fontWeight: w700,
                  color: AppColors.deepChocolate,
                ),
              ),
            )
          : Image.asset(path, fit: BoxFit.cover),
    );
  }
}

/// Chip label kecil (golongan darah, jenis kelamin, kategori).
class SoftChip extends StatelessWidget {
  const SoftChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.selected = false,
    this.dense = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final bool selected;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent = color ?? AppColors.goldenCaramel;
    final Color fg = selected ? Colors.white : accent;
    final Color bg = selected ? accent : accent.withValues(alpha: 0.10);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? AppSpacing.sm : AppSpacing.md,
            vertical: dense ? 4 : AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: dense ? 13 : 15, color: fg),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: dense ? 11.5 : 12.5,
                  fontWeight: w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Baris icon + label + nilai, dipakai di kartu "Tentang".
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.goldenCaramel),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: t.bodySmall),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: t.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Snackbar ringkas dengan warna status semantik.
class AppSnack {
  const AppSnack._();

  static void show(
    BuildContext context,
    String message, {
    bool success = false,
    bool error = false,
  }) {
    final Color bg = error
        ? AppColors.danger
        : success
        ? AppColors.clinicalTeal
        : AppColors.darkEspresso;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              Icon(
                error
                    ? Icons.error_outline_rounded
                    : success
                    ? Icons.check_circle_outline_rounded
                    : Icons.info_outline_rounded,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: bg,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
