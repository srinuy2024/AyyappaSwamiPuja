/// యూజర్ సొంత గొంతు మోడల్ (User Own Voice Model & Training Architecture)
enum VoicePlaybackMode {
  priestOnly,           // కేవలం వేద పండితుని స్వరంతో శ్రవణం
  userOnly,             // యూజర్ సొంత గొంతు రికార్డింగ్ / క్లోన్డ్ వాయిస్‌తో
  priestLeadUserFollow, // గురు ముఖతః: పండితుడు చెప్పిన తర్వాత యూజర్ స్వరం ప్రతిధ్వనించడం
}

class UserVoiceProfile {
  String profileId;
  String devoteeName;
  bool isCustomVoiceActive;
  VoicePlaybackMode playbackMode;
  Map<String, String> recordedAudioPaths; // stepId -> local audio filepath
  DateTime lastTrainedDate;

  UserVoiceProfile({
    this.profileId = 'default_user_voice',
    this.devoteeName = 'శ్రీనివాసరావు గారు',
    this.isCustomVoiceActive = false,
    this.playbackMode = VoicePlaybackMode.priestOnly,
    Map<String, String>? recordedAudioPaths,
    DateTime? lastTrainedDate,
  })  : recordedAudioPaths = recordedAudioPaths ?? {},
        lastTrainedDate = lastTrainedDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'profileId': profileId,
    'devoteeName': devoteeName,
    'isCustomVoiceActive': isCustomVoiceActive,
    'playbackMode': playbackMode.index,
    'recordedAudioPaths': recordedAudioPaths,
    'lastTrainedDate': lastTrainedDate.toIso8601String(),
  };

  factory UserVoiceProfile.fromJson(Map<String, dynamic> json) {
    return UserVoiceProfile(
      profileId: json['profileId'] ?? 'default_user_voice',
      devoteeName: json['devoteeName'] ?? 'శ్రీనివాసరావు గారు',
      isCustomVoiceActive: json['isCustomVoiceActive'] ?? false,
      playbackMode: VoicePlaybackMode.values[json['playbackMode'] ?? 0],
      recordedAudioPaths: Map<String, String>.from(json['recordedAudioPaths'] ?? {}),
      lastTrainedDate: json['lastTrainedDate'] != null 
          ? DateTime.parse(json['lastTrainedDate']) 
          : DateTime.now(),
    );
  }
}
