// lib/services/cloud_library_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/library_model.dart';

/// క్లౌడ్ & ఆఫ్-లైన్ హైబ్రిడ్ లైబ్రరీ సర్వీస్ (Zero-Bloat Progressive Caching)
class CloudLibraryService {
  static final CloudLibraryService _instance = CloudLibraryService._internal();
  factory CloudLibraryService() => _instance;
  CloudLibraryService._internal();

  List<YogaCategory> _cachedYogas = [];
  bool _isInitialized = false;

  List<YogaCategory> get yogas => _cachedYogas;

  /// సర్వీస్ ప్రారంభం: లోకల్ బండిల్ & క్యాష్ నుండి వేగంగా లోడ్ చేయడం
  Future<void> initialize() async {
    if (_isInitialized && _cachedYogas.isNotEmpty) return;

    try {
      // 1. స్థానిక మ్యానిఫెస్ట్ నుండి లోడ్ చేయడం (100% ఆఫ్‌లైన్ గ్యారంటీ)
      final manifestString = await rootBundle.loadString('assets/data/library_manifest.json');
      final Map<String, dynamic> data = json.decode(manifestString);

      if (data.containsKey('yogas')) {
        _cachedYogas = (data['yogas'] as List<dynamic>)
            .map((cat) => YogaCategory.fromJson(cat))
            .toList();
      }
      _isInitialized = true;
    } catch (e) {
      // ఫాల్‌బ్యాక్ సేఫ్టీ
      _cachedYogas = [];
    }
  }

  /// ఏదైనా బుక్ లేదా వ్రతం యొక్క లోకల్ క్యాష్ ఫైల్ పాత్ పొందడం
  Future<String?> getLocalCachedFilePath(String itemId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/sacred_library/$itemId.json');
      if (await file.exists()) {
        return file.path;
      }
    } catch (_) {}
    return null;
  }

  /// కంటెంట్‌ను శాశ్వతంగా లోకల్ డిస్క్‌లో దాచుట (Download Once, Read Forever)
  Future<void> saveToLocalCache(String itemId, String contentJson) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final libraryDir = Directory('${dir.path}/sacred_library');
      if (!await libraryDir.exists()) {
        await libraryDir.create(recursive: true);
      }
      final file = File('${libraryDir.path}/$itemId.json');
      await file.writeAsString(contentJson);
    } catch (_) {}
  }
}
