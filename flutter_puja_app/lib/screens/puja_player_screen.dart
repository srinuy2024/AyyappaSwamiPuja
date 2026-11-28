import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../models/puja_step_model.dart';
import '../models/deity_model.dart';
import '../services/panchangam_service.dart';
import '../services/deity_puja_data_service.dart';
import '../data/ashtottara_data.dart';
import '../services/vedic_voice_service.dart';
import '../constants/app_typography.dart';

/// భక్తుల కొరకు సులభతరమైన సమగ్ర పూజా ప్లేయర్ (లఘు పూజ vs సంపూర్ణ షోడశోపచార పూజ)
class PujaPlayerScreen extends StatefulWidget {
  final DevoteeProfile devoteeProfile;
  final String deityId;
  final String deityNameTe;
  final String deityNameSa;
  final bool initialIsFullMode;
  final PanchangamData? initialPanchang;

  const PujaPlayerScreen({
    Key? key,
    required this.devoteeProfile,
    required this.deityId,
    required this.deityNameTe,
    required this.deityNameSa,
    this.initialIsFullMode = false,
    this.initialPanchang,
  }) : super(key: key);

  @override
  _PujaPlayerScreenState createState() => _PujaPlayerScreenState();
}

class _PujaPlayerScreenState extends State<PujaPlayerScreen> {
  int _currentStepIndex = 0;
  String _activeScript = 'telugu'; // 'telugu' or 'sanskrit'
  bool _isMeaningExpanded = false;
  int _ashtottaraCounter = 1; // 1 to 108
  bool _showAll108Names = false;
  late bool _isFullMode;
  double _slokaFontSize = 15.5; // Allows full sloka lines to fit without wrapping

  final VedicVoiceService _voiceService = VedicVoiceService();
  bool _isAutoAdvanceActive = false;
  bool _isAuto108Active = false;

  void _decreaseFontSize() {
    if (_slokaFontSize > 12.5) {
      setState(() {
        _slokaFontSize -= 1.0;
      });
      _saveFontSize();
    }
  }

  void _increaseFontSize() {
    if (_slokaFontSize < 22.0) {
      setState(() {
        _slokaFontSize += 1.0;
      });
      _saveFontSize();
    }
  }

  Future<void> _saveFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('puja_sloka_font_size', _slokaFontSize);
    } catch (_) {}
  }

  Future<void> _saveScript(String script) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('puja_active_script', script);
    } catch (_) {}
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFontSize = prefs.getDouble('puja_sloka_font_size');
      final savedScript = prefs.getString('puja_active_script');
      if (mounted) {
        setState(() {
          if (savedFontSize != null && savedFontSize >= 12.0 && savedFontSize <= 22.0) {
            _slokaFontSize = savedFontSize;
          }
          if (savedScript != null && (savedScript == 'telugu' || savedScript == 'sanskrit')) {
            _activeScript = savedScript;
          }
        });
      }
    } catch (_) {}
  }

  late PanchangamData _panchang;
  late DeityModel _deity;
  late List<PujaStepModel> _pujaSteps;

  @override
  void initState() {
    super.initState();
    _isFullMode = widget.initialIsFullMode;
    _panchang = widget.initialPanchang ?? PanchangamService.calculate(DateTime.now());
    _deity = DeityPujaDataService.getDeity(widget.deityId);
    _reloadSteps();
    _loadPreferences();
    _voiceService.initTts();
    _voiceService.addListener(_onVoiceUpdate);
  }

  void _onVoiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _stopVoice();
    _voiceService.removeListener(_onVoiceUpdate);
    super.dispose();
  }

  void _reloadSteps() {
    setState(() {
      _pujaSteps = DeityPujaDataService.getDeitySteps(
        deityId: widget.deityId,
        profile: widget.devoteeProfile,
        panchang: _panchang,
        isFullMode: _isFullMode,
      );
      if (_currentStepIndex >= _pujaSteps.length) {
        _currentStepIndex = 0;
      }
    });
  }

  void _togglePujaMode(bool isFull) {
    if (_isFullMode == isFull) return;
    _stopVoice();
    setState(() {
      _isFullMode = isFull;
      _currentStepIndex = 0;
      _ashtottaraCounter = 1;
      _showAll108Names = false;
      _reloadSteps();
    });
  }

  void _nextStep() {
    if (_currentStepIndex < _pujaSteps.length - 1) {
      _stopVoice();
      HapticFeedback.selectionClick();
      setState(() {
        _currentStepIndex++;
        _isMeaningExpanded = false;
        _ashtottaraCounter = 1;
        _showAll108Names = false;
      });
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      _stopVoice();
      HapticFeedback.selectionClick();
      setState(() {
        _currentStepIndex--;
        _isMeaningExpanded = false;
        _ashtottaraCounter = 1;
        _showAll108Names = false;
      });
    }
  }

  void _playCurrentVoice() {
    final step = _pujaSteps[_currentStepIndex];
    final isAshtottaraStep = step.hasInteractiveCounter || step.stepId == 'ashtottara';

    if (isAshtottaraStep) {
      final names = _getActiveAshtottaraList(step);
      _startAuto108Chant(names);
      return;
    }

    final text = _activeScript == 'telugu' ? step.slokaTe : step.slokaSa;
    _voiceService.speakSloka(
      text,
      script: _activeScript,
      onComplete: () {
        if (_isAutoAdvanceActive && mounted && _currentStepIndex < _pujaSteps.length - 1) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && _isAutoAdvanceActive) {
              _nextStep();
              _playCurrentVoice();
            }
          });
        }
      },
    );
  }

  void _stopVoice() {
    _isAuto108Active = false;
    _voiceService.stop();
  }

  void _startAuto108Chant(List<String> names) {
    if (_isAuto108Active) {
      _stopAuto108Chant();
      return;
    }
    _isAuto108Active = true;
    setState(() {});
    _speakNext108Name(names);
  }

  void _speakNext108Name(List<String> names) {
    if (!_isAuto108Active || !mounted) return;
    if (_ashtottaraCounter > 108) {
      _isAuto108Active = false;
      setState(() {});
      return;
    }

    final currentIdx = _ashtottaraCounter - 1;
    if (currentIdx >= names.length) {
      _isAuto108Active = false;
      setState(() {});
      return;
    }

    final rawName = names[currentIdx];
    final cleanName = VedicVoiceService.cleanSlokaForSpeech(rawName);

    _voiceService.speakSloka(
      cleanName,
      script: _activeScript,
      onComplete: () {
        if (!_isAuto108Active || !mounted) return;
        HapticFeedback.lightImpact();
        if (_ashtottaraCounter < 108) {
          setState(() {
            _ashtottaraCounter++;
          });
          Future.delayed(const Duration(milliseconds: 1400), () {
            _speakNext108Name(names);
          });
        } else {
          HapticFeedback.mediumImpact();
          _isAuto108Active = false;
          setState(() {});
        }
      },
    );
  }

  void _stopAuto108Chant() {
    _isAuto108Active = false;
    _voiceService.stop();
    setState(() {});
  }

  void _incrementFlowerCounter() {
    if (_ashtottaraCounter < 108) {
      HapticFeedback.lightImpact();
      setState(() {
        _ashtottaraCounter++;
      });
      if (_ashtottaraCounter == 108) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  void _decrementFlowerCounter() {
    if (_ashtottaraCounter > 1) {
      HapticFeedback.selectionClick();
      setState(() {
        _ashtottaraCounter--;
      });
    }
  }

  void _resetFlowerCounter() {
    setState(() {
      _ashtottaraCounter = 1;
    });
  }

  List<String> _getActiveAshtottaraList(PujaStepModel step) {
    if (step.stepId.contains('ganapathi')) {
      return AshtottaraData.ganapathi108;
    } else if (step.stepId.contains('subramanya')) {
      return AshtottaraData.subramanya108;
    }
    return _deity.ashtottaraNamesTe;
  }

  String _getActiveAshtottaraTitle(PujaStepModel step) {
    if (step.stepId.contains('ganapathi')) {
      return 'శ్రీ మహాగణపతి 108 దివ్య నామావళి';
    } else if (step.stepId.contains('subramanya')) {
      return 'శ్రీ సుబ్రహ్మణ్యేశ్వర 108 దివ్య నామావళి';
    }
    return 'శ్రీ ${_deity.nameTe} 108 దివ్య నామావళి';
  }

  @override
  Widget build(BuildContext context) {
    final step = _pujaSteps[_currentStepIndex];
    final progress = (_currentStepIndex + 1) / _pujaSteps.length;
    final isAshtottaraStep = step.hasInteractiveCounter || step.stepId == 'ashtottara';
    final activeAshtottaraList = _getActiveAshtottaraList(step);

    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        backgroundColor: AppTypography.primaryMaroon,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'శ్రీ ${_deity.nameTe} పూజ',
              style: AppTypography.teluguSloka(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'దశ ${step.stepNumber} / ${_pujaSteps.length} • ${_isFullMode ? "షోడశోపచార" : "నిత్య లఘు"}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFFDE68A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          // Quick Mode Toggle (లఘు / షోడశ)
          TextButton(
            onPressed: () => _togglePujaMode(!_isFullMode),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              minimumSize: const Size(40, 28),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white30),
              ),
              child: Text(
                _isFullMode ? 'షోడశ' : 'లఘు',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Script Switcher (తెలుగు / దేవనాగరి)
          TextButton(
            onPressed: () {
              final newScript = _activeScript == 'telugu' ? 'sanskrit' : 'telugu';
              HapticFeedback.selectionClick();
              setState(() {
                _activeScript = newScript;
              });
              _saveScript(newScript);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              minimumSize: const Size(40, 28),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: AppTypography.sacredGold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _activeScript == 'telugu' ? 'संस्कृतम्' : 'తెలుగు',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Settings popup menu (Font Size A- / A+)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 21),
            tooltip: 'ఫాంట్ సైజు',
            onSelected: (val) {
              if (val == 'increase_font') _increaseFontSize();
              if (val == 'decrease_font') _decreaseFontSize();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                enabled: false,
                child: Text('ఫాంట్ సైజు: ${_slokaFontSize.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              PopupMenuItem(
                value: 'increase_font',
                child: Row(
                  children: const [
                    Icon(Icons.text_increase, color: AppTypography.primaryMaroon, size: 20),
                    SizedBox(width: 8),
                    Text('ఫాంట్ పెంచండి (A+)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'decrease_font',
                child: Row(
                  children: const [
                    Icon(Icons.text_decrease, color: AppTypography.primaryMaroon, size: 20),
                    SizedBox(width: 8),
                    Text('ఫాంట్ తగ్గించండి (A-)'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 3.5,
            backgroundColor: Colors.amber.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTypography.templeDeepOrange),
          ),
        ),
      ),
      body: Column(
        children: [
          // Scrollable Sacred Ritual Area (Consistent 16.0 Padding)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Unified Master Sacred Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppTypography.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTypography.cardBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.shade900.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card Header: Step Badge + Title + Compact Audio Button
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: AppTypography.primaryMaroon.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'దశ ${step.stepNumber}',
                                style: const TextStyle(
                                  color: AppTypography.primaryMaroon,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _activeScript == 'telugu' ? step.titleTe : step.titleSa,
                                style: AppTypography.sacredHeader(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Compact Discrete Audio Play/Stop Button
                            IconButton(
                              icon: Icon(
                                _voiceService.isPlaying || _isAuto108Active
                                    ? Icons.stop_circle
                                    : Icons.volume_up_outlined,
                                color: _voiceService.isPlaying || _isAuto108Active
                                    ? const Color(0xFFDC2626)
                                    : AppTypography.primaryMaroon,
                                size: 24,
                              ),
                              tooltip: _voiceService.isPlaying ? 'ఆడియో ఆపండి' : 'పఠనం వినండి',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              onPressed: _voiceService.isPlaying || _isAuto108Active
                                  ? _stopVoice
                                  : _playCurrentVoice,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Action Prompt Ribbon (Inside Card)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('👉 ', style: TextStyle(fontSize: 14)),
                              Expanded(
                                child: Text(
                                  _activeScript == 'telugu'
                                      ? step.actionInstructionTe
                                      : step.actionInstructionSa,
                                  style: AppTypography.instructionText(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppTypography.textAmber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Sankalpam Quick Elements Reference Card
                        if (step.stepId == 'sankalpam') ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text('🪔 ', style: TextStyle(fontSize: 15)),
                                    Text(
                                      'సంకల్ప పంచాంగ వివరాలు (Key Elements):',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppTypography.primaryMaroon,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _buildSankalpaPill('సంవత్సరం', 'శ్రీ ${_panchang.samvatsaraTe} నామ'),
                                    _buildSankalpaPill('ఆయనం', _panchang.ayanaTe),
                                    _buildSankalpaPill('ఋతువు', _panchang.rithuTe),
                                    _buildSankalpaPill('మాసం', '${_panchang.masaTe} మాసం'),
                                    _buildSankalpaPill('పక్షం', _panchang.pakshaTe),
                                    _buildSankalpaPill('తిథి', _panchang.tithiTe),
                                    _buildSankalpaPill('వారం', _panchang.vasaraTe),
                                    _buildSankalpaPill('నక్షత్రం', '${_panchang.nakshatraTe} నక్షత్రం'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Sloka or Sacred Text
                        if (!isAshtottaraStep || _showAll108Names) ...[
                          SelectableText(
                            _activeScript == 'telugu' ? step.slokaTe : step.slokaSa,
                            style: _activeScript == 'telugu'
                                ? AppTypography.teluguSloka(fontSize: _slokaFontSize)
                                : AppTypography.sanskritSloka(fontSize: _slokaFontSize + 0.5),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        // Interactive 108 Ashtottara Flower Offering Counter
                        if (isAshtottaraStep) ...[
                          if (!_showAll108Names) ...[
                            // Active Name Highlight Banner
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: AppTypography.counterBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTypography.counterBorder, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTypography.primaryMaroon,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'నామం $_ashtottaraCounter / 108',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              if (_isAuto108Active) {
                                                _stopAuto108Chant();
                                              } else {
                                                _startAuto108Chant(activeAshtottaraList);
                                              }
                                            },
                                            icon: Icon(
                                              _isAuto108Active ? Icons.stop_circle : Icons.play_circle_fill,
                                              size: 16,
                                              color: _isAuto108Active ? const Color(0xFFDC2626) : AppTypography.primaryMaroon,
                                            ),
                                            label: Text(
                                              _isAuto108Active ? 'ఆపండి' : 'ఆటో చాంట్',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _isAuto108Active ? const Color(0xFFDC2626) : AppTypography.primaryMaroon,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: _resetFlowerCounter,
                                            icon: const Icon(Icons.refresh, size: 16, color: AppTypography.sacredGoldDark),
                                            label: const Text(
                                              'మొదటి నుండి',
                                              style: TextStyle(fontSize: 12, color: AppTypography.sacredGoldDark, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Deity-Specific 108 Name
                                  SelectableText(
                                    activeAshtottaraList[(_ashtottaraCounter - 1).clamp(0, activeAshtottaraList.length - 1)],
                                    style: AppTypography.teluguSloka(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppTypography.primaryMaroon,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),

                                  // Pushparchana Big Tap Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton.icon(
                                      onPressed: _ashtottaraCounter < 108 ? _incrementFlowerCounter : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTypography.vibrantOrange,
                                        foregroundColor: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      icon: const Text('🌸', style: TextStyle(fontSize: 24)),
                                      label: Text(
                                        _ashtottaraCounter < 108
                                            ? 'పుష్పార్చన సమర్పించండి (+1)'
                                            : '✓ 108 పుష్పార్చన సంపూర్ణం!',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Fast Previous / Next Mini Steppers
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton.icon(
                                        onPressed: _ashtottaraCounter > 1 ? _decrementFlowerCounter : null,
                                        icon: const Icon(Icons.arrow_back, size: 16),
                                        label: const Text('మునుపటి నామం'),
                                      ),
                                      TextButton.icon(
                                        onPressed: _ashtottaraCounter < 108 ? _incrementFlowerCounter : null,
                                        icon: const Icon(Icons.arrow_forward, size: 16),
                                        label: const Text('తరువాతి నామం'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          // Toggle All 108 List View Button
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showAll108Names = !_showAll108Names;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTypography.primaryMaroon,
                              side: const BorderSide(color: AppTypography.primaryMaroon, width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: Icon(_showAll108Names ? Icons.view_carousel : Icons.format_list_numbered, size: 20),
                            label: Text(
                              _showAll108Names
                                  ? '🌸 పుష్పార్చన కౌంటర్ స్క్రీన్ కి మారండి'
                                  : '📜 సమగ్ర 108 నామాల పూర్తి జాబితా చూడండి',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),

                          // Full 108 List View when toggled
                          if (_showAll108Names) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.amber.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    _getActiveAshtottaraTitle(step),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTypography.primaryMaroon,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Divider(height: 18),
                                  ...activeAshtottaraList.asMap().entries.map((entry) {
                                    final idx = entry.key + 1;
                                    final name = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 32,
                                            child: Text(
                                              '$idx.',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTypography.sacredGoldDark,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: AppTypography.teluguSloka(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.w600,
                                                color: AppTypography.textPrimary,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ],
                        // Spiritual Meaning & Inner Significance Accordion (Inside Card)
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: _isMeaningExpanded,
                            tilePadding: EdgeInsets.zero,
                            onExpansionChanged: (val) {
                              setState(() {
                                _isMeaningExpanded = val;
                              });
                            },
                            leading: const Text('💡', style: TextStyle(fontSize: 18)),
                            title: const Text(
                              'ఈ దశ యొక్క తాత్పర్యం & అంతరార్థం',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: AppTypography.primaryMaroon,
                              ),
                            ),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Text('📜 ', style: TextStyle(fontSize: 14)),
                                      Text(
                                        'సరళ తాత్పర్యం:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.5,
                                          color: AppTypography.primaryMaroon,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step.tatparyam,
                                    style: AppTypography.meaningText(fontSize: 14.0),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: const [
                                      Text('🧘 ', style: TextStyle(fontSize: 14)),
                                      Text(
                                        'ఆధ్యాత్మిక అంతరార్థం:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.5,
                                          color: AppTypography.primaryMaroon,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step.spiritualMeaning,
                                    style: AppTypography.meaningText(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Controls (Consistent 16px Padding)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.amber.shade200, width: 1.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Previous Step Button
                  if (_currentStepIndex > 0)
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTypography.primaryMaroon,
                          side: const BorderSide(color: AppTypography.primaryMaroon, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: const Text('మునుపటి', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      ),
                    )
                  else
                    const Spacer(flex: 4),

                  const SizedBox(width: 8),

                  // Auto-Puja Toggle Pill
                  if (!isAshtottaraStep)
                    InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _isAutoAdvanceActive = !_isAutoAdvanceActive;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: _isAutoAdvanceActive
                              ? AppTypography.templeDeepOrange.withOpacity(0.12)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isAutoAdvanceActive
                                ? AppTypography.templeDeepOrange
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isAutoAdvanceActive
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 14,
                              color: _isAutoAdvanceActive
                                  ? AppTypography.templeDeepOrange
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ఆటో పూజ',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: _isAutoAdvanceActive
                                    ? AppTypography.templeDeepOrange
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  // Next Step / Finish Button
                  Expanded(
                    flex: 5,
                    child: ElevatedButton.icon(
                      onPressed: _currentStepIndex < _pujaSteps.length - 1
                          ? _nextStep
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('✓ శ్రీ ${_deity.nameTe} పూజ సంపూర్ణంగా ముగిసింది! స్వామి అనుగ్రహం కలుగుగాక!'),
                                  backgroundColor: AppTypography.successGreen,
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentStepIndex < _pujaSteps.length - 1
                            ? AppTypography.primaryMaroon
                            : AppTypography.successGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: Icon(
                        _currentStepIndex < _pujaSteps.length - 1 ? Icons.arrow_forward : Icons.check_circle,
                        size: 18,
                      ),
                      label: Text(
                        _currentStepIndex < _pujaSteps.length - 1 ? 'తదుపరి దశ' : 'సంపూర్ణం 🪔',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSankalpaPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTypography.textMuted,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: AppTypography.primaryMaroon,
            ),
          ),
        ],
      ),
    );
  }
}
