import 'package:flutter/material.dart';

/// సమగ్ర దేవతా పూజా డేటా మోడల్
class DeityModel {
  final String id;
  final String nameTe;
  final String nameSa;
  final String avatarTitle;
  final String icon;
  final Color themeColor;
  final String dhyanamTe;
  final String dhyanamSa;
  final String dhyanamMeaning;
  final String shodasaTe;
  final String shodasaSa;
  final List<String> ashtottaraNamesTe;
  final String ashtottaraTitleTe;
  final String ashtottaraTitleSa;
  final String naivedyamTe;
  final String naivedyamSa;
  final String prasadam;
  final String harathiTe;
  final String harathiSa;
  final String mangalamTe;
  final String mangalamSa;
  final String? stotramTitleTe;
  final String? stotramTe;
  final String? stotramSa;
  final String? stotramMeaning;

  DeityModel({
    required this.id,
    required this.nameTe,
    required this.nameSa,
    required this.avatarTitle,
    required this.icon,
    required this.themeColor,
    required this.dhyanamTe,
    required this.dhyanamSa,
    required this.dhyanamMeaning,
    required this.shodasaTe,
    required this.shodasaSa,
    required this.ashtottaraNamesTe,
    required this.ashtottaraTitleTe,
    required this.ashtottaraTitleSa,
    required this.naivedyamTe,
    required this.naivedyamSa,
    required this.prasadam,
    required this.harathiTe,
    required this.harathiSa,
    required this.mangalamTe,
    required this.mangalamSa,
    this.stotramTitleTe,
    this.stotramTe,
    this.stotramSa,
    this.stotramMeaning,
  });
}
