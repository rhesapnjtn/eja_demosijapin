import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Standar tiga state layar (Aturan 8 AGENTS.md — Zero Red-Screen):
/// [LoadingView] saat memuat, [ErrorView] saat gagal, [EmptyView]
/// saat data kosong. Tidak boleh ada layar merah tanpa penjelasan.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.lines = 3, this.showAvatar = true});

  final int lines;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: AppColors.creamLinen,
        highlightColor: AppColors.surfaceCard,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.lg,
          AppSpacing.screenH,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (showAvatar) ...<Widget>[
              const Row(
                children: <Widget>[
                  Bone.circle(size: 62),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Bone.text(words: 2, fontSize: 15),
                        SizedBox(height: AppSpacing.sm),
                        Bone.text(words: 3, fontSize: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            for (int i = 0; i < lines; i++) ...<Widget>[
              Bone(
                height: 76,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

/// State gagal: pesan ramah + tombol "Coba Lagi".
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: AppSpacing.screen,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.dangerContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Gagal memuat data', style: t.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ??
                  'Periksa koneksi internet Anda, lalu coba muat ulang '
                      'halaman ini.',
              textAlign: TextAlign.center,
              style: t.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (onRetry != null)
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
          ],
        ),
      ),
    );
  }
}

/// State kosong: data tidak ada, bukan error.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: AppSpacing.screen,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.creamLinen,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.warmUmber),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: t.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(message!, textAlign: TextAlign.center, style: t.bodySmall),
            ],
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
