import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pemilih tanggal dengan batas usiawi 0–120 tahun dan gaya seluler.
class AppDatePicker {
  const AppDatePicker._();

  static const int minAge = 0;
  static const int maxAge = 120;

  static DateTime _firstDate() =>
      DateTime.now().subtract(const Duration(days: 365 * maxAge));

  static DateTime _lastDate() =>
      DateTime.now().subtract(const Duration(days: 365 * minAge));

  /// Tanggal lahir pasien. Batas atas = hari ini (tanpa jam).
  static Future<DateTime?> pickBirthDate(
    BuildContext context, {
    DateTime? initialDate,
  }) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    DateTime initial = DateTime(today.year - 25, today.month, today.day);
    if (initialDate != null) {
      initial = initialDate.isAfter(today) ? today : initialDate;
    }

    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _firstDate(),
      lastDate: _lastDate(),
      helpText: 'Pilih tanggal lahir',
      cancelText: 'Batal',
      confirmText: 'Simpan',
      builder: (BuildContext context, Widget? child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: AppColors.surfaceOverlay,
            surfaceTintColor: Colors.transparent,
            headerBackgroundColor: AppColors.goldenCaramel,
            headerForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
