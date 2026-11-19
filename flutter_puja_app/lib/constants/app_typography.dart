import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// తెలుగు & సంస్కృత లిపుల కొరకు దోషరహిత టైపోగ్రఫీ (Flawless Bilingual Typography)
class AppTypography {
  // Sacred Colors
  static const Color primaryMaroon = Color(0xFF6B1414);
  static const Color sacredGold = Color(0xFFD97706);
  static const Color templeDeepOrange = Color(0xFFC2410C);
  static const Color saffronBackground = Color(0xFFFFFBEB);
  static const Color darkCardBg = Color(0xFF26120B);

  /// తెలుగు శ్లోకాలు & మంత్రాల ఫాంట్ (Telugu Font Style with safe line heights)
  static TextStyle teluguSloka({
    double fontSize = 18.0,
    FontWeight fontWeight = FontWeight.w600,
    Color color = const Color(0xFF2B1704),
    double height = 1.65, // Essential for Telugu conjuncts / ఒత్తులు
  }) {
    return GoogleFonts.mandali(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: 0.3,
    );
  }

  /// సంస్కృత దేవనాగరి ఫాంట్ (Sanskrit Devanagari Style with safe line heights)
  static TextStyle sanskritSloka({
    double fontSize = 18.5,
    FontWeight fontWeight = FontWeight.w600,
    Color color = const Color(0xFF381A08),
    double height = 1.6, // Essential for Devanagari Matras & Halant
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
    Color color = const Color(0xFF451A03),
    double height = 1.6,
  }) {
    return GoogleFonts.notoSansTelugu(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
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
      height: 1.3,
    );
  }
}
