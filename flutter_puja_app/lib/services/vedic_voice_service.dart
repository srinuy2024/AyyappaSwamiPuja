import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum VedicTtsState { playing, stopped, paused }

/// వేద పండిత స్వర ఉచ్ఛారణ సర్వీస్ (Vedic Priest Voice & Sloka Recitation Service)
class VedicVoiceService extends ChangeNotifier {
  static final VedicVoiceService _instance = VedicVoiceService._internal();
  factory VedicVoiceService() => _instance;
  VedicVoiceService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  VedicTtsState _state = VedicTtsState.stopped;
  VedicTtsState get state => _state;
  bool get isPlaying => _state == VedicTtsState.playing;
  bool get isPaused => _state == VedicTtsState.paused;

  bool _isAutoAdvance = false;
  bool get isAutoAdvance => _isAutoAdvance;
  set isAutoAdvance(bool val) {
    _isAutoAdvance = val;
    notifyListeners();
  }

  // ప్రశాంతమైన వేద పఠన టెంపో మరియు గంభీర స్వర పిచ్
  double _speechRate = 0.76; // Calm, measured Vedic chanting tempo
  double _pitch = 0.92;      // Deeper, resonant priest voice
  double _volume = 1.0;

  double get speechRate => _speechRate;
  double get pitch => _pitch;

  VoidCallback? _onCompletionCallback;
  bool _isInitialized = false;

  /// సర్వీస్ ప్రారంభం & హ్యాండ్లర్స్ సెటప్
  Future<void> initTts() async {
    if (_isInitialized) return;

    try {
      _flutterTts.setStartHandler(() {
        _state = VedicTtsState.playing;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _state = VedicTtsState.stopped;
        notifyListeners();
        if (_onCompletionCallback != null) {
          _onCompletionCallback!();
        }
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint('VedicVoiceService Error: $msg');
        _state = VedicTtsState.stopped;
        notifyListeners();
      });

      _flutterTts.setCancelHandler(() {
        _state = VedicTtsState.stopped;
        notifyListeners();
      });

      _flutterTts.setPauseHandler(() {
        _state = VedicTtsState.paused;
        notifyListeners();
      });

      _flutterTts.setContinueHandler(() {
        _state = VedicTtsState.playing;
        notifyListeners();
      });

      // Default Vedic audio profile
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(_pitch);
      await _flutterTts.setVolume(_volume);

      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize FlutterTts: $e');
    }
  }

  /// శ్లోకాన్ని స్పష్టమైన వేదోచ్ఛారణతో చదువుట
  Future<void> speakSloka(
    String slokaText, {
    String script = 'telugu',
    VoidCallback? onComplete,
  }) async {
    await initTts();

    _onCompletionCallback = onComplete;
    final cleaned = cleanSlokaForSpeech(slokaText);
    if (cleaned.trim().isEmpty) return;

    try {
      // లిపి ప్రాధాన్యతను బట్టి సరైన వాయిస్ లాంగ్వేజ్ ఎంపిక
      if (script == 'sanskrit') {
        final isSaAvailable = await _flutterTts.isLanguageAvailable('sa-IN');
        if (isSaAvailable == true) {
          await _flutterTts.setLanguage('sa-IN');
        } else {
          final isHiAvailable = await _flutterTts.isLanguageAvailable('hi-IN');
          if (isHiAvailable == true) {
            await _flutterTts.setLanguage('hi-IN');
          } else {
            await _flutterTts.setLanguage('te-IN');
          }
        }
      } else {
        await _flutterTts.setLanguage('te-IN');
      }

      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(_pitch);
      await _flutterTts.speak(cleaned);
    } catch (e) {
      debugPrint('TTS speak error: $e');
      _state = VedicTtsState.stopped;
      notifyListeners();
    }
  }

  /// ఆడియో ఆపివేయుట
  Future<void> stop() async {
    try {
      _onCompletionCallback = null;
      await _flutterTts.stop();
      _state = VedicTtsState.stopped;
      notifyListeners();
    } catch (_) {}
  }

  /// ఆడియో పాజ్ చేయుట
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      _state = VedicTtsState.paused;
      notifyListeners();
    } catch (_) {}
  }

  /// పాజ్ చేసిన ఆడియోను కొనసాగించుట
  Future<void> resume() async {
    try {
      // FlutterTts does not have uniform resume on all Android engines;
      // if resume is not native, we notify state
      _state = VedicTtsState.playing;
      notifyListeners();
    } catch (_) {}
  }

  /// శ్లోకం చదివేటప్పుడు అనవసరమైన చిహ్నాలు తొలగించి సహజమైన విరామం (Pauses) కల్పించుట
  static String cleanSlokaForSpeech(String raw) {
    var text = raw;

    // Remove stage instructions in parentheses like (స్వాములు), (గురుస్వామి), (2 సార్లు)
    text = text.replaceAll(RegExp(r'\([^)]*\)'), ' ');

    // Clean sloka markers like || 1 ||, || 2 ||, etc.
    text = text.replaceAll(RegExp(r'\|\|\s*\d+\s*\|\|'), ' , ');
    text = text.replaceAll('||', ' , ');
    text = text.replaceAll('|', ' , ');

    // Clean bullets and decorators
    text = text.replaceAll('•', ' , ');
    text = text.replaceAll('—', ' ');
    text = text.replaceAll('-', ' ');
    text = text.replaceAll('*', '');
    text = text.replaceAll('#', '');

    // Replace avagraha with smooth elongation
    text = text.replaceAll('ऽ', '');

    // Collapse repeated whitespace and commas
    text = text.replaceAll(RegExp(r',\s*,+'), ',');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// వేగం మార్చుకొనుట (0.6x to 1.0x)
  Future<void> setRate(double rate) async {
    _speechRate = rate.clamp(0.5, 1.2);
    await _flutterTts.setSpeechRate(_speechRate);
    notifyListeners();
  }

  /// పిచ్ మార్చుకొనుట (0.7x to 1.2x)
  Future<void> setPitch(double p) async {
    _pitch = p.clamp(0.6, 1.4);
    await _flutterTts.setPitch(_pitch);
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
