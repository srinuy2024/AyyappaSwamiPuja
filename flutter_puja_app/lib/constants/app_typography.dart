import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// తెలుగు & సంస్కృత లిపుల కొరకు దోషరహిత టైపోగ్రఫీ & హై-కాంట్రాస్ట్ కలర్స్ (WCAG AAA Compliant)
class AppTypography {
  // Sacred Primary Colors
  static const Color primaryMaroon = Color(0xFF7F1D1D);       // Deep Temple Burgundy
  static const Color primaryMaroonDark = Color(0xFF581C87);   // Deep Divine Violet
  static const Color sacredGold = Color(0xFFD97706);          // Auspicious Amber Gold
  static const Color sacredGoldDark = Color(0xFFB45309);      // Deep Golden Brown
  static const Color templeDeepOrange = Color(0xFFC2410C);    // Traditional Saffron
  static const Color vibrantOrange = Color(0xFFEA580C);       // Bright Temple Vermillion

  // High-Contrast Backgrounds & Surfaces
  static const Color saffronBackground = Color(0xFFFFFDF5);   // Crisp Divine Warm Cream (Light Theme)
  static const Color cardSurface = Color(0xFFFFFFFF);         // Pure Card White for max readability
  static const Color cardSurfaceWarm = Color(0xFFFFFBEB);     // Gentle Warm Tint Card
  static const Color darkCardBg = Color(0xFF1E140F);          // Deep Charcoal-Maroon for Dark Cards
  static const Color cardBorder = Color(0xFFFDE68A);          // Soft Golden Amber Border
  static const Color cardBorderDark = Color(0xFFB45309);      // Defined Accent Border

  // Crystal-Clear High-Contrast Foreground Text Colors (WCAG AAA)
  static const Color textPrimary = Color(0xFF0F172A);         // Deep Slate Charcoal (16:1 contrast on white)
  static const Color textSecondary = Color(0xFF334155);       // Dark Slate for instructions & details
  static const Color textMuted = Color(0xFF64748B);           // Subtle helper text
  static const Color textMaroon = Color(0xFF7F1D1D);          // Sacred Sloka Red-Burgundy
  static const Color textAmber = Color(0xFF92400E);           // Deep Amber for sacred accents
  static const Color textWhite = Color(0xFFFFFFFF);           // Pure White for buttons & headers

  // Auspicious Accent Status Colors
  static const Color successGreen = Color(0xFF047857);        // Emerald for completed steps
  static const Color counterBg = Color(0xFFFEF3C7);           // Soft Golden for 108 Flower Counter
  static const Color counterBorder = Color(0xFFF59E0B);       // Golden outline

  /// తెలుగు శ్లోకాలు & మంత్రాల ఫాంట్ (Telugu Font Style with safe line heights)
  static TextStyle teluguSloka({
    double fontSize = 15.5,
    FontWeight fontWeight = FontWeight.w600,
    Color color = textMaroon,
    double height = 1.65, // Generous line height ensures Telugu matras/vothulu never collide
  }) {
    return GoogleFonts.mandali(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: 0.1,
    );
  }

  /// సంస్కృత దేవనాగరి ఫాంట్ (Sanskrit Devanagari Style with safe line heights)
  static TextStyle sanskritSloka({
    double fontSize = 18.5,
    FontWeight fontWeight = FontWeight.w600,
    Color color = const Color(0xFF431407), // Deep Earth Brown
    double height = 1.7, // Essential for Devanagari Matras & Halant
  }) {
    return GoogleFonts.notoSansDevanagari(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: 0.2,
    );
  }

  /// ప్రతిపదార్థం & తాత్పర్యం ఫాంట్ (Meaning / Tatparyam readable style)
  static TextStyle meaningText({
    double fontSize = 15.5,
    FontWeight fontWeight = FontWeight.w400,
    Color color = textPrimary,
    double height = 1.65,
  }) {
    return GoogleFonts.notoSansTelugu(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// పూజా ఆదేశాలు & సూచనలు (Clear Ritual Action Instructions)
  static TextStyle instructionText({
    double fontSize = 15.0,
    FontWeight fontWeight = FontWeight.w500,
    Color color = textSecondary,
  }) {
    return GoogleFonts.notoSansTelugu(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.5,
    );
  }

  /// హెడ్డింగ్స్ (Sacred Headings)
  static TextStyle sacredHeader({
    double fontSize = 22.0,
    FontWeight fontWeight = FontWeight.w700,
    Color color = primaryMaroon,
  }) {
    return GoogleFonts.mandali(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.35,
    );
  }
}
