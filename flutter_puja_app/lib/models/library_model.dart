// lib/models/library_model.dart
import 'package:flutter/material.dart';

class YogaCategory {
  final String id;
  final String titleTe;
  final String titleSa;
  final String subtitle;
  final String iconName;
  final Color themeColor;
  final List<LibraryItem> items;

  YogaCategory({
    required this.id,
    required this.titleTe,
    required this.titleSa,
    required this.subtitle,
    required this.iconName,
    required this.themeColor,
    required this.items,
  });

  factory YogaCategory.fromJson(Map<String, dynamic> json) {
    Color parseColor(String? hex) {
      if (hex == null) return const Color(0xFFB91C1C);
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    }

    return YogaCategory(
      id: json['id'] ?? '',
      titleTe: json['title_te'] ?? '',
      titleSa: json['title_sa'] ?? '',
      subtitle: json['subtitle'] ?? '',
      iconName: json['icon_name'] ?? 'temple_hindu',
      themeColor: parseColor(json['color_hex']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => LibraryItem.fromJson(item))
          .toList(),
    );
  }
}

class LibraryItem {
  final String id;
  final String titleTe;
  final String titleSa;
  final String description;
  final String type; // 'vratam', 'puja', 'stotra', 'scripture', 'tool', 'purana', 'suktam'
  final String? duration;
  final bool isOfflineReady;

  LibraryItem({
    required this.id,
    required this.titleTe,
    required this.titleSa,
    required this.description,
    required this.type,
    this.duration,
    this.isOfflineReady = true,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      id: json['id'] ?? '',
      titleTe: json['title_te'] ?? '',
      titleSa: json['title_sa'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'scripture',
      duration: json['duration'],
      isOfflineReady: json['is_offline_ready'] ?? true,
    );
  }
}

class VratamSamagriItem {
  final String nameTe;
  final String quantity;
  final String significance;
  bool isChecked;

  VratamSamagriItem({
    required this.nameTe,
    required this.quantity,
    required this.significance,
    this.isChecked = false,
  });
}

class VratamKathaChapter {
  final int chapterNumber;
  final String titleTe;
  final String titleSa;
  final String summary;
  final String fullKathaTe;
  final String spiritualMessage;

  VratamKathaChapter({
    required this.chapterNumber,
    required this.titleTe,
    required this.titleSa,
    required this.summary,
    required this.fullKathaTe,
    required this.spiritualMessage,
  });
}

class GitaSlokaModel {
  final int chapter;
  final int verse;
  final String slokaSa;
  final String slokaTe;
  final String wordByWord;
  final String tatparyam;
  final String practicalLesson;

  GitaSlokaModel({
    required this.chapter,
    required this.verse,
    required this.slokaSa,
    required this.slokaTe,
    required this.wordByWord,
    required this.tatparyam,
    required this.practicalLesson,
  });
}
