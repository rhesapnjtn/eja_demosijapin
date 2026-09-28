import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Logo RS dalam kontainer squircle karamel.
///
/// Aset vektor logo resmi belum tersedia di `assets/`, sehingga logo
/// digambar dari ikon Material sampai aset resmi tersedia.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.goldenCaramel,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppColors.shadowCard,
      ),
      child: Icon(
        Icons.local_hospital_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}

/// Wordmark "SIIJAPIN" beserta nama rumah sakit.
class AppWordmark extends StatelessWidget {
  const AppWordmark({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'SIIJAPIN',
          style: TextStyle(
            fontSize: size,
            height: 1.1,
            fontWeight: w800,
            letterSpacing: 2.4,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'RSUP Dr. Sitanala Tangerang',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: w600,
            letterSpacing: 0.4,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
