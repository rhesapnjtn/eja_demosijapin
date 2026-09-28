import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Kartu dasar SIIJAPIN: putih, border tipis, radius 20, bayangan hangat.
///
/// Latar kartu memakai [Material] (bukan `DecoratedBox`) supaya efek
/// sentuh [ListTile] dan [InkWell] di dalamnya tetap terlihat.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: padding ?? AppSpacing.card,
      child: child,
    );

    final Widget surface = Material(
      type: MaterialType.canvas,
      color: AppColors.surfaceCard,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
        side: BorderSide(color: AppColors.outline),
      ),
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, borderRadius: AppRadius.cardRadius, child: content),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(boxShadow: AppColors.shadowCard),
      child: surface,
    );
  }
}
