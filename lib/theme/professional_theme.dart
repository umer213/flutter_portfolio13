import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium dark portfolio theme with stunning visuals
class ProfessionalTheme {
  // Dark theme colors - Premium palette
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color darkBg2 = Color(0xFF1A1F3A);
  static const Color cardBg = Color(0xFF1E2440);

  // Vibrant accent colors
  static const Color electricBlue = Color(0xFF00D4FF);
  static const Color neonPurple = Color(0xFFB57BFF);
  static const Color cyanGlow = Color(0xFF00FFF0);
  static const Color pinkAccent = Color(0xFFFF006E);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8C5D6);
  static const Color textMuted = Color(0xFF8892A6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [electricBlue, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [cyanGlow, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [darkBg, darkBg2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: neonPurple,
        surface: cardBg,
        background: darkBg,
        error: pinkAccent,
        onPrimary: darkBg,
        onSecondary: darkBg,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.orbitron(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 64,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.orbitron(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 48,
          letterSpacing: -1.0,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.orbitron(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 36,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 28,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 22,
          height: 1.3,
        ),
        titleMedium: GoogleFonts.poppins(
          color: textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 18,
          height: 1.7,
          letterSpacing: 0.15,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 16,
          height: 1.6,
          letterSpacing: 0.25,
        ),
        labelLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg.withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // Glass effect decoration
  static BoxDecoration glassCard({
    Color? color,
    double blur = 10,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: (color ?? cardBg).withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(24),
      border: hasBorder
          ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Glow decoration
  static BoxDecoration glowDecoration({
    required Color color,
    double blurRadius = 30,
    double spreadRadius = 5,
  }) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.5),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }
}
