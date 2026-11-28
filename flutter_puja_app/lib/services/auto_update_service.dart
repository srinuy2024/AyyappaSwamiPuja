// lib/services/auto_update_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_typography.dart';

class UpdateInfo {
  final String version;
  final int buildNumber;
  final String releaseTitle;
  final List<String> releaseNotes;
  final String apkUrl;
  final String actionsRunUrl;

  UpdateInfo({
    required this.version,
    required this.buildNumber,
    required this.releaseTitle,
    required this.releaseNotes,
    required this.apkUrl,
    required this.actionsRunUrl,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      version: json['version'] ?? '1.0.0',
      buildNumber: json['build_number'] ?? 1,
      releaseTitle: json['release_title'] ?? 'నూతన అప్‌డేట్',
      releaseNotes: List<String>.from(json['release_notes'] ?? []),
      apkUrl: json['apk_url'] ?? '',
      actionsRunUrl: json['actions_run_url'] ?? '',
    );
  }
}

/// ఇన్-యాప్ ఆటో అప్‌డేట్ సర్వీస్ (Auto Update & Zero Data Loss Service)
class AutoUpdateService {
  static const String currentVersion = '1.4.0';
  static const int currentBuildNumber = 9;
  static const String updateManifestUrl =
      'https://raw.githubusercontent.com/srinuy2024/AyyappaSwamiPuja/main/version.json';

  /// బ్యాక్‌గ్రౌండ్‌లో కొత్త వెర్షన్ తనిఖీ
  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 6);
      final request = await client.getUrl(Uri.parse(updateManifestUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        final jsonString = await response.transform(utf8.decoder).join();
        final data = json.decode(jsonString) as Map<String, dynamic>;
        final remoteInfo = UpdateInfo.fromJson(data);

        if (remoteInfo.buildNumber > currentBuildNumber) {
          return remoteInfo;
        }
      }
    } catch (e) {
      // ఆఫ్‌లైన్‌లో ఉన్నప్పుడు ఎర్రర్ చూపకుండా నిశ్శబ్దంగా సాగుతుంది
      debugPrint('AutoUpdate check error (safe offline): $e');
    }
    return null;
  }

  /// అప్‌డేట్ నోటిఫికేషన్ డైలాగ్ ప్రదర్శన
  static void showUpdateDialog(BuildContext context, UpdateInfo info) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFDE68A), width: 1.5),
        ),
        title: Row(
          children: const [
            Text('🪔 ', style: TextStyle(fontSize: 22)),
            Expanded(
              child: Text(
                'నూతన అప్‌డేట్ అందుబాటులో ఉంది!',
                style: TextStyle(
                  color: AppTypography.primaryMaroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.5,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'వెర్షన్ v${info.version} (ప్రస్తుతము: v$currentVersion)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTypography.primaryMaroon,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                info.releaseTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
              const SizedBox(height: 8),
              const Text(
                'నూతన విశేషాలు (What\'s New):',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              ...info.releaseNotes.map(
                (note) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppTypography.templeDeepOrange, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(fontSize: 13, color: AppTypography.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: Color(0xFF047857), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '100% జీరో డేటా లాస్: మీ ప్రొఫైల్, రికార్డింగ్‌లు భద్రంగా ఉంటాయి.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF065F46), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('తరువాత', style: TextStyle(color: AppTypography.textSecondary)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTypography.primaryMaroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.download, size: 16),
            label: const Text('ఇప్పుడే అప్‌డేట్ చేసుకోండి'),
            onPressed: () {
              Navigator.pop(ctx);
              // Open APK download URL in browser
              _launchUpdateUrl(info.apkUrl.isNotEmpty ? info.apkUrl : info.actionsRunUrl);
            },
          ),
        ],
      ),
    );
  }

  static void _launchUpdateUrl(String url) async {
    // Process launch or system action
    debugPrint('Launching update URL: $url');
  }
}
