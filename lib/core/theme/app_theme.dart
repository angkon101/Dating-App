import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryRose = Color(0xFFE11D48); // Passionate & refined rose
  static const Color primaryRoseLight = Color(0xFFFFF1F2);
  static const Color primaryRoseHover = Color(0xFFBE123C);

  static const Color slateDark = Color(0xFF0F172A); // Midnight charcoal
  static const Color slateCardDark = Color(0xFF1E293B);
  static const Color slateSurfaceDark = Color(0xFF090D16);

  static const Color slateLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  static const Color textMainLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  static const Color textMainDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3B8);

  static const Color emeraldVerified = Color(0xFF10B981);
  static const Color amberSuperlike = Color(0xFFF59E0B);
  static const Color skyPrivacy = Color(0xFF0EA5E9);

  // Light Theme
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: slateLight,
      colorScheme: const ColorScheme.light(
        primary: primaryRose,
        onPrimary: Colors.white,
        secondary: slateDark,
        surface: surfaceWhite,
        onSurface: textMainLight,
        outline: borderLight,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textMainLight,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textMainLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textMainLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMutedLight,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceWhite,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textMainLight,
        ),
        iconTheme: const IconThemeData(color: textMainLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRose,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceWhite,
        elevation: 2,
        indicatorColor: primaryRoseLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: primaryRose);
          }
          return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textMutedLight);
        }),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: slateSurfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryRose,
        onPrimary: Colors.white,
        secondary: Colors.white,
        surface: slateCardDark,
        onSurface: textMainDark,
        outline: borderDark,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textMainDark,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textMainDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textMainDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMutedDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: slateSurfaceDark,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textMainDark,
        ),
        iconTheme: const IconThemeData(color: textMainDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRose,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: slateCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: slateCardDark,
        elevation: 2,
        indicatorColor: primaryRose.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: primaryRose);
          }
          return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textMutedDark);
        }),
      ),
    );
  }
}

