import 'package:flutter/material.dart';

/// Palet Warna SIIJAPIN — RSUP Dr. Sitanala Tangerang (Kemenkes RI).
///
/// SSOT warna lived di `DESIGN.md` bagian "Color Palette".
/// Nilai kontainer/bayangan di bawah adalah turunan (tint) dari palet
/// utama agar tetap satu keluarga warna, bukan warna baru.
class AppColors {
  const AppColors._();

  // Brand Coklat Khas Sitanala
  static const Color darkEspresso = Color(0xFF1C140E);
  static const Color deepChocolate = Color(0xFF493306);
  static const Color warmUmber = Color(0xFF614925);
  static const Color warmBronze = Color(0xFF825B0B);
  static const Color goldenCaramel = Color(0xFFAA7409);
  static const Color softSand = Color(0xFFD3B577);
  static const Color creamLinen = Color(0xFFF7F3ED);

  // Surface & Latar Belakang
  /// Level 0 — background layar.
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFAF8F5);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceOverlay = Color(0xFFFFFFFF);

  // Kontainer Aksen
  static const Color primaryContainer = Color(0xFFF3E3C1);
  static const Color clinicalTealContainer = Color(0xFFD2E7E4);
  static const Color onClinicalTealContainer = Color(0xFF0B423C);

  // Status Klinis & Semantik
  static const Color clinicalTeal = Color(0xFF1B7369);
  static const Color danger = Color(0xFFAA2D11);
  static const Color dangerContainer = Color(0xFFFAE0DB);
  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFBEBD3);
  static const Color success = Color(0xFF15803D);

  // Tipografi & Teks
  static const Color textPrimary = Color(0xFF1C140E);
  static const Color textSecondary = Color(0xFF5C5046);
  static const Color textMuted = Color(0xFF8C7E74);

  // Garis Tepi & Pemisah
  static const Color outline = Color(0xFFEAE2D8);
  static const Color focusBorder = Color(0xFFAA7409);

  // Bayangan Hangat (Level 1 = 4px, Level 2 = 8px)
  static const List<BoxShadow> shadowCard = <BoxShadow>[
    BoxShadow(color: Color(0x0F1C140E), blurRadius: 4, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> shadowActive = <BoxShadow>[
    BoxShadow(color: Color(0x1F1C140E), blurRadius: 8, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> shadowModal = <BoxShadow>[
    BoxShadow(color: Color(0x331C140E), blurRadius: 24, offset: Offset(0, 8)),
  ];

  // Scrim / Latar Modal
  static const Color backdrop = Color(0x661C140E);

  // Alias peran semantik agar widget cukup menulis "primary"/"secondary".
  static const Color primary = goldenCaramel;
  static const Color secondary = clinicalTeal;
  static const Color info = clinicalTeal;
  static const Color textTertiary = textMuted;

  // Alias lama (Sitanala v1) — pertahankan agar kode existing tidak rusak.
  static const Color brandDarkEspresso = darkEspresso;
  static const Color brandDeepChocolate = deepChocolate;
  static const Color brandWarmUmber = warmUmber;
  static const Color brandWarmBronze = warmBronze;
  static const Color brandGoldenCaramel = goldenCaramel;
  static const Color brandSoftSand = softSand;
  static const Color brandCreamLinen = creamLinen;
  static const Color surfaceBg = background;
  static const Color dangerCrimson = danger;
  static const Color warningAmber = warning;
  static const Color successEmerald = success;
  static const Color borderSubtle = outline;
  static const Color borderFocus = focusBorder;
}
