import 'package:flutter/foundation.dart';
import '../models/user_voice_model.dart';

/// భక్తుని సొంత గొంతు రికార్డింగ్ & ట్రైనింగ్ సర్వీస్ (User Voice Model Service)
class VoiceRecorderService extends ChangeNotifier {
  final UserVoiceProfile _voiceProfile = UserVoiceProfile();
  bool _isRecording = false;
  String? _currentRecordingStepId;

  UserVoiceProfile get profile => _voiceProfile;
  bool get isRecording => _isRecording;
  String? get currentRecordingStepId => _currentRecordingStepId;

  /// వాయిస్ మోడ్ మార్పిడి (Priest / User Own Voice / Duet)
  void setPlaybackMode(VoicePlaybackMode mode) {
    _voiceProfile.playbackMode = mode;
    notifyListeners();
  }

  /// యూజర్ కస్టమ్ వాయిస్ ఆన్/ఆఫ్
  void toggleCustomVoice(bool isEnabled) {
    _voiceProfile.isCustomVoiceActive = isEnabled;
    notifyListeners();
  }

  /// దశ ఆధారంగా గొంతు రికార్డింగ్ ప్రారంభించుట
  Future<void> startRecording(String stepId) async {
    _isRecording = true;
    _currentRecordingStepId = stepId;
    notifyListeners();
    // Native audio recorder hook (record / flutter_sound)
  }

  /// రికార్డింగ్ ముగించి స్థానికంగా భద్రపరచుట
  Future<void> stopRecording() async {
    if (!_isRecording) return;
    if (_currentRecordingStepId != null) {
      _voiceProfile.recordedAudioPaths[_currentRecordingStepId!] = 'local_recordings/${_currentRecordingStepId}.m4a';
    }
    _isRecording = false;
    _currentRecordingStepId = null;
    notifyListeners();
  }

  /// సదరు దశకు యూజర్ గొంతు రికార్డింగ్ ఉందా లేదా?
  bool hasUserVoice(String stepId) {
    return _voiceProfile.recordedAudioPaths.containsKey(stepId);
  }
}
