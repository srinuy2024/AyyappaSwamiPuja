import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// భక్తుని కుటుంబ వివరాల మోడల్ (Devotee Profile Model)
class DevoteeProfile {
  String gotram;
  String kartaName;
  String spouseName;
  String childrenNames;
  String pincode;
  String city;
  String janmaNakshatra;
  String selectedDeityId;
  String preferredScript; // 'telugu' or 'sanskrit' or 'both'

  DevoteeProfile({
    this.gotram = 'పైడిపూండ్ల',
    this.kartaName = 'శ్రీనివాసరావు',
    this.spouseName = 'వాణి',
    this.childrenNames = 'హర్ష, అఖిల్',
    this.pincode = '522034',
    this.city = 'గుంటూరు',
    this.janmaNakshatra = 'ఉత్తరాషాఢ',
    this.selectedDeityId = 'ayyappa',
    this.preferredScript = 'both',
  });

  static const String _prefsKey = 'devotee_family_profile';

  /// స్థానిక నిల్వ (SharedPreferences) నుండి భక్తుని వివరాలు లోడ్ చేయుట
  static Future<DevoteeProfile> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_prefsKey);
      if (str != null && str.isNotEmpty) {
        final data = jsonDecode(str) as Map<String, dynamic>;
        return DevoteeProfile.fromJson(data);
      }
    } catch (_) {}
    return DevoteeProfile();
  }

  /// భక్తుని వివరాలను స్థానిక నిల్వ (SharedPreferences) లో శాశ్వతంగా భద్రపరచుట
  Future<bool> saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_prefsKey, jsonEncode(toJson()));
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> toJson() => {
    'gotram': gotram,
    'kartaName': kartaName,
    'spouseName': spouseName,
    'childrenNames': childrenNames,
    'pincode': pincode,
    'city': city,
    'janmaNakshatra': janmaNakshatra,
    'selectedDeityId': selectedDeityId,
    'preferredScript': preferredScript,
  };

  factory DevoteeProfile.fromJson(Map<String, dynamic> json) {
    return DevoteeProfile(
      gotram: json['gotram'] ?? 'పైడిపూండ్ల',
      kartaName: json['kartaName'] ?? 'శ్రీనివాసరావు',
      spouseName: json['spouseName'] ?? 'వాణి',
      childrenNames: json['childrenNames'] ?? 'హర్ష, అఖిల్',
      pincode: json['pincode'] ?? '522034',
      city: json['city'] ?? 'గుంటూరు',
      janmaNakshatra: json['janmaNakshatra'] ?? 'ఉత్తరాషాఢ',
      selectedDeityId: json['selectedDeityId'] ?? 'ayyappa',
      preferredScript: json['preferredScript'] ?? 'both',
    );
  }
}
