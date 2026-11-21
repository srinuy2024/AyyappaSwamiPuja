import 'package:flutter/material.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../models/puja_step_model.dart';
import '../models/deity_model.dart';
import '../services/panchangam_service.dart';
import '../services/deity_puja_data_service.dart';
import '../constants/app_typography.dart';

/// భక్తుల కొరకు సులభతరమైన సమగ్ర పూజా ప్లేయర్ (లఘు పూజ vs సంపూర్ణ షోడశోపచార పూజ)
class PujaPlayerScreen extends StatefulWidget {
  final DevoteeProfile devoteeProfile;
  final String deityId;
  final String deityNameTe;
  final String deityNameSa;
  final bool initialIsFullMode;

  const PujaPlayerScreen({
    Key? key,
    required this.devoteeProfile,
    required this.deityId,
    required this.deityNameTe,
    required this.deityNameSa,
    this.initialIsFullMode = false,
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

  late PanchangamData _panchang;
  late DeityModel _deity;
  late List<PujaStepModel> _pujaSteps;

  @override
  void initState() {
    super.initState();
    _isFullMode = widget.initialIsFullMode;
    _panchang = PanchangamService.calculate(DateTime.now());
    _deity = DeityPujaDataService.getDeity(widget.deityId);
    _reloadSteps();
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
      setState(() {
        _currentStepIndex--;
        _isMeaningExpanded = false;
        _ashtottaraCounter = 1;
        _showAll108Names = false;
      });
    }
  }

  void _incrementFlowerCounter() {
    if (_ashtottaraCounter < 108) {
      setState(() {
        _ashtottaraCounter++;
      });
    }
  }

  void _decrementFlowerCounter() {
    if (_ashtottaraCounter > 1) {
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

  @override
  Widget build(BuildContext context) {
    final step = _pujaSteps[_currentStepIndex];
    final progress = (_currentStepIndex + 1) / _pujaSteps.length;
    final isAshtottaraStep = step.hasInteractiveCounter || step.stepId == 'ashtottara';

    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        backgroundColor: AppTypography.primaryMaroon,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _deity.nameTe,
              style: AppTypography.teluguSloka(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            Text(
              _isFullMode ? 'సంపూర్ణ షోడశోపచార పూజ (16 ఉపచారాలు)' : 'నిత్య లఘు పూజ (10 దశలు)',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFFDE68A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          // Script Switcher (తెలుగు / దేవనాగరి)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTypography.sacredGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                setState(() {
                  _activeScript = _activeScript == 'telugu' ? 'sanskrit' : 'telugu';
                });
              },
              child: Text(
                _activeScript == 'telugu' ? 'संस्कृतम्' : 'తెలుగు',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Mode Switcher & Progress Bar Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.amber.shade200, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Daily vs Full Mode Segmented Bar
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _togglePujaMode(false),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: !_isFullMode ? AppTypography.templeDeepOrange : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !_isFullMode ? AppTypography.templeDeepOrange : Colors.grey.shade300,
                            ),
                          ),
                          alignment: TextAlign.center,
                          child: Text(
                            '⚡ నిత్య లఘు పూజ (15-20 ని)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: !_isFullMode ? Colors.white : AppTypography.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _togglePujaMode(true),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: _isFullMode ? AppTypography.primaryMaroon : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isFullMode ? AppTypography.primaryMaroon : Colors.grey.shade300,
                            ),
                          ),
                          alignment: TextAlign.center,
                          child: Text(
                            '🪔 సంపూర్ణ షోడశ పూజ (35-45 ని)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _isFullMode ? Colors.white : AppTypography.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Step Progression Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'దశ ${step.stepNumber} / ${_pujaSteps.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: AppTypography.primaryMaroon,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}% పూర్తయింది',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTypography.sacredGoldDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.amber.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTypography.templeDeepOrange),
                  ),
                ),
              ],
            ),
          ),

          // 2. Clear Action Prompt Banner (స్పష్టమైన విధి ఆదేశం)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('👉 ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    _activeScript == 'telugu'
                        ? step.actionInstructionTe
                        : step.actionInstructionSa,
                    style: AppTypography.instructionText(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppTypography.textAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Scrollable Sacred Ritual Sloka & Meaning Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step Title
                  Text(
                    _activeScript == 'telugu' ? step.titleTe : step.titleSa,
                    style: AppTypography.sacredHeader(fontSize: 21),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Main Sacred Card (Pure White with Gold Border for maximum readability)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTypography.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTypography.cardBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.shade900.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sloka or Sacred Text
                        if (!isAshtottaraStep || _showAll108Names) ...[
                          SelectableText(
                            _activeScript == 'telugu' ? step.slokaTe : step.slokaSa,
                            style: _activeScript == 'telugu'
                                ? AppTypography.teluguSloka(fontSize: 18.0)
                                : AppTypography.sanskritSloka(fontSize: 18.5),
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
                                  const SizedBox(height: 12),

                                  // Deity-Specific 108 Name
                                  SelectableText(
                                    _deity.ashtottaraNamesTe[_ashtottaraCounter - 1],
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
                                    'శ్రీ ${_deity.nameTe} 108 దివ్య నామావళి',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTypography.primaryMaroon,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Divider(height: 18),
                                  ..._deity.ashtottaraNamesTe.asMap().entries.map((entry) {
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. Spiritual Meaning & Inner Significance Accordion (స్పష్టమైన అంతరార్థం)
                  Card(
                    elevation: 1.5,
                    color: AppTypography.cardSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.amber.shade200),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: _isMeaningExpanded,
                      onExpansionChanged: (val) {
                        setState(() {
                          _isMeaningExpanded = val;
                        });
                      },
                      leading: const Text('💡', style: TextStyle(fontSize: 22)),
                      title: const Text(
                        'ఈ దశ యొక్క సరళ తాత్పర్యం & అంతరార్థం',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppTypography.primaryMaroon,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 16),
                              Row(
                                children: const [
                                  Text('📜 ', style: TextStyle(fontSize: 16)),
                                  Text(
                                    'సరళ తాత్పర్యం:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppTypography.primaryMaroon,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                step.tatparyam,
                                style: AppTypography.meaningText(fontSize: 15.0),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: const [
                                  Text('🧘 ', style: TextStyle(fontSize: 16)),
                                  Text(
                                    'ఆధ్యాత్మిక అంతరార్థం (Spiritual Secret):',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppTypography.primaryMaroon,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                step.spiritualMeaning,
                                style: AppTypography.meaningText(fontSize: 15.0),
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

          // 5. Bottom Navigation Controls (మునుపటి / తదుపరి దశ బటన్లు)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.amber.shade200, width: 1.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
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
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('మునుపటి దశ', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  else
                    const Spacer(flex: 4),

                  const SizedBox(width: 12),

                  // Next Step / Finish Button
                  Expanded(
                    flex: 6,
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
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: Icon(
                        _currentStepIndex < _pujaSteps.length - 1 ? Icons.arrow_forward : Icons.check_circle,
                        size: 20,
                      ),
                      label: Text(
                        _currentStepIndex < _pujaSteps.length - 1 ? 'తదుపరి దశ' : 'పూజ సంపూర్ణం 🪔',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
}
