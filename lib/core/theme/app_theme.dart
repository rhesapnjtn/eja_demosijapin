import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

/// Sistem kisi 8-point: semua jarak adalah kelipatan 8 (atau 4 untuk
/// mikro-jarak).
class AppSpacing {
  const AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;

  /// Padding horizontal layar: 16 dp untuk ponsel standar.
  static const double screenH = 16;

  /// Padding internal kartu: 16 atas-bawah, 20 kiri-kanan.
  static const double cardV = 16;
  static const double cardH = 20;

  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: md,
  );
  static const EdgeInsets card = EdgeInsets.symmetric(
    horizontal: cardH,
    vertical: cardV,
  );
  static const EdgeInsets cardTight = EdgeInsets.all(md);
  static const EdgeInsets listGap = EdgeInsets.symmetric(vertical: sm);
}

/// Bentuk: pil untuk tombol dan chip, squircle 14–20 px untuk kartu.
class AppRadius {
  const AppRadius._();
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;

  /// Alias lama; sama dengan [lg] (20 px).
  static const double xl = 20;

  static const double xxl = 28;
  static const double pill = 9999;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fieldRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chipRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius squircle = BorderRadius.all(Radius.circular(md));
  static const BorderRadius sheetRadius = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}

/// Token tipografi SIIJAPIN.
///
/// display 26/34 w700, headline 20/28 w600, title 16/24 w600,
/// body 14/22 w400, label 12/16 w600.
class AppText {
  const AppText._();

  static const double displaySize = 26;
  static const double displayHeight = 34;
  static const double headlineSize = 20;
  static const double headlineHeight = 28;
  static const double titleSize = 16;
  static const double titleHeight = 24;
  static const double bodySize = 14;
  static const double bodyHeight = 22;
  static const double labelSize = 12;
  static const double labelHeight = 16;
}

class AppTheme {
  const AppTheme._();

  static const String fontFamily = 'Plus Jakarta Sans';
  static const List<String> fontFamilyFallback = <String>[
    'Inter',
    'sans-serif',
  ];

  /// Alias lama; sama dengan [light].
  static ThemeData get lightTheme => light;

  static ThemeData get light {
    const ColorScheme scheme = ColorScheme.light(
      // Aksen vokal utama: karamel keemasan.
      primary: AppColors.goldenCaramel,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.deepChocolate,
      // Teal penyeimbang untuk konten medis.
      secondary: AppColors.clinicalTeal,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.clinicalTealContainer,
      onSecondaryContainer: AppColors.onClinicalTealContainer,
      tertiary: AppColors.softSand,
      onTertiary: AppColors.deepChocolate,
      tertiaryContainer: AppColors.creamLinen,
      onTertiaryContainer: AppColors.deepChocolate,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: AppColors.dangerContainer,
      onErrorContainer: AppColors.danger,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.outline,
      outlineVariant: AppColors.creamLinen,
    );

    return _base(scheme).copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    final TextTheme text = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: text.headlineSmall,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(color: AppColors.outline),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardH,
          vertical: AppSpacing.xs,
        ),
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodySmall,
        iconColor: AppColors.textSecondary,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.creamLinen,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: AppColors.textMuted),
        labelStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: text.labelLarge?.copyWith(
          color: AppColors.goldenCaramel,
        ),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        errorStyle: text.bodySmall?.copyWith(color: AppColors.danger),
        border: _fieldBorder(AppColors.outline),
        enabledBorder: _fieldBorder(AppColors.outline),
        focusedBorder: _fieldBorder(AppColors.focusBorder, width: 2),
        errorBorder: _fieldBorder(AppColors.danger),
        focusedErrorBorder: _fieldBorder(AppColors.danger, width: 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: text.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: w700,
          ),
          backgroundColor: AppColors.goldenCaramel,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.outline,
          disabledForegroundColor: AppColors.textMuted,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: text.labelLarge,
          foregroundColor: AppColors.goldenCaramel,
          side: const BorderSide(color: AppColors.goldenCaramel, width: 1.4),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: text.labelLarge,
          foregroundColor: AppColors.goldenCaramel,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.creamLinen,
        selectedColor: AppColors.goldenCaramel,
        side: const BorderSide(color: AppColors.outline),
        labelStyle: text.labelMedium,
        secondaryLabelStyle: text.labelMedium?.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: const StadiumBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primaryContainer,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? text.labelMedium?.copyWith(
                  color: AppColors.goldenCaramel,
                  fontWeight: w700,
                )
              : text.labelMedium?.copyWith(color: AppColors.textSecondary),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColors.goldenCaramel
                : AppColors.textSecondary,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceOverlay,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceOverlay,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkEspresso,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.goldenCaramel,
        linearTrackColor: AppColors.creamLinen,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected)
              ? AppColors.goldenCaramel
              : AppColors.softSand,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(text.labelMedium),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.outline),
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[const AppThemeTokens()],
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.fieldRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    TextStyle? s(
      double size,
      double height,
      FontWeight weight,
      Color color, {
      double? ls,
    }) => TextStyle(
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      color: color,
      letterSpacing: ls,
    );

    // Token persis dari design system: 26/34 w700, 20/28 w600,
    // 16/24 w600, 14/22 w400, 12/16 w600.
    return TextTheme(
      displayLarge: s(
        AppText.displaySize,
        AppText.displayHeight,
        w700,
        AppColors.textPrimary,
        ls: -0.5,
      ),
      displayMedium: s(
        AppText.displaySize,
        AppText.displayHeight,
        w700,
        AppColors.textPrimary,
        ls: -0.5,
      ),
      displaySmall: s(22, 28, w700, AppColors.textPrimary, ls: -0.4),
      headlineLarge: s(
        AppText.headlineSize,
        AppText.headlineHeight,
        w600,
        AppColors.textPrimary,
        ls: -0.28,
      ),
      headlineMedium: s(
        AppText.headlineSize,
        AppText.headlineHeight,
        w600,
        AppColors.textPrimary,
        ls: -0.28,
      ),
      headlineSmall: s(18, 24, w600, AppColors.textPrimary, ls: -0.2),
      titleLarge: s(18, 24, w600, AppColors.textPrimary),
      titleMedium: s(
        AppText.titleSize,
        AppText.titleHeight,
        w600,
        AppColors.textPrimary,
      ),
      titleSmall: s(14, 20, w600, AppColors.textPrimary),
      bodyLarge: s(16, 24, w400, AppColors.textPrimary),
      bodyMedium: s(
        AppText.bodySize,
        AppText.bodyHeight,
        w400,
        AppColors.textSecondary,
      ),
      bodySmall: s(13, 20, w400, AppColors.textSecondary),
      labelLarge: s(
        AppText.labelSize + 1,
        AppText.labelHeight + 4,
        w700,
        AppColors.goldenCaramel,
        ls: 0.24,
      ),
      labelMedium: s(
        AppText.labelSize,
        AppText.labelHeight,
        w600,
        AppColors.textSecondary,
        ls: 0.24,
      ),
      labelSmall: s(11, 16, w600, AppColors.textMuted, ls: 0.22),
    );
  }
}

/// Token tambahan agar widget bisa membaca nilai design system
/// tanpa perlu menduplikasi angka.
@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    this.cardElevation = AppColors.shadowCard,
    this.activeElevation = AppColors.shadowActive,
    this.modalElevation = AppColors.shadowModal,
    this.scrim = AppColors.backdrop,
    this.accent = AppColors.goldenCaramel,
    this.clinical = AppColors.clinicalTeal,
    this.transitionDuration = const Duration(milliseconds: 250),
  });

  final List<BoxShadow> cardElevation;
  final List<BoxShadow> activeElevation;
  final List<BoxShadow> modalElevation;
  final Color scrim;
  final Color accent;
  final Color clinical;
  final Duration transitionDuration;

  @override
  AppThemeTokens copyWith({
    List<BoxShadow>? cardElevation,
    List<BoxShadow>? activeElevation,
    List<BoxShadow>? modalElevation,
    Color? scrim,
    Color? accent,
    Color? clinical,
    Duration? transitionDuration,
  }) {
    return AppThemeTokens(
      cardElevation: cardElevation ?? this.cardElevation,
      activeElevation: activeElevation ?? this.activeElevation,
      modalElevation: modalElevation ?? this.modalElevation,
      scrim: scrim ?? this.scrim,
      accent: accent ?? this.accent,
      clinical: clinical ?? this.clinical,
      transitionDuration: transitionDuration ?? this.transitionDuration,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) return this;
    return AppThemeTokens(
      cardElevation: t < 0.5 ? cardElevation : other.cardElevation,
      activeElevation: t < 0.5 ? activeElevation : other.activeElevation,
      modalElevation: t < 0.5 ? modalElevation : other.modalElevation,
      scrim: Color.lerp(scrim, other.scrim, t) ?? scrim,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      clinical: Color.lerp(clinical, other.clinical, t) ?? clinical,
      transitionDuration: t < 0.5
          ? transitionDuration
          : other.transitionDuration,
    );
  }

  /// Akses cepat: `AppThemeTokens.of(context)`.
  static AppThemeTokens of(BuildContext context) {
    return Theme.of(context).extension<AppThemeTokens>() ??
        const AppThemeTokens();
  }
}

/// Singkatan agar tema tetap ringkas dan konsisten.
const FontWeight w400 = FontWeight.w400;
const FontWeight w500 = FontWeight.w500;
const FontWeight w600 = FontWeight.w600;
const FontWeight w700 = FontWeight.w700;
const FontWeight w800 = FontWeight.w800;
