// lib/screens/japa_mala_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_typography.dart';

class JapaMalaScreen extends StatefulWidget {
  const JapaMalaScreen({super.key});

  @override
  State<JapaMalaScreen> createState() => _JapaMalaScreenState();
}

class _JapaMalaScreenState extends State<JapaMalaScreen> {
  int _currentBead = 0;
  int _completedMalas = 0;
  int _totalJapaCount = 0;

  final List<Map<String, String>> _mantras = [
    {
      'name': 'శ్రీ అయ్యప్ప మూల మంత్రం',
      'mantra': 'ఓం స్వామియే శరణం అయ్యప్ప',
      'deity': 'శ్రీ ధర్మశాస్తా',
    },
    {
      'name': 'శివ పంచాక్షరీ మంత్రం',
      'mantra': 'ఓం నమః శివాయ',
      'deity': 'పరమశివుడు',
    },
    {
      'name': 'గాయత్రీ మహా మంత్రం',
      'mantra': 'ఓం భూర్భువః స్వః తత్సవితుర్వరేణ్యం భర్గో దేవస్య ధీమహి ధియో యో నః ప్రచోదయాత్',
      'deity': 'గాయత్రీ దేవి',
    },
    {
      'name': 'మృత్యుంజయ మంత్రం',
      'mantra': 'ఓం త్రయంబకం యజామహే సుగంధిం పుష్టివర్ధనం ఉర్వారుకమివ బంధనాన్ మృత్యోర్ముక్షీయ మాఽమృతాత్',
      'deity': 'మృత్యుంజయుడు',
    },
    {
      'name': 'శ్రీరామ తారక మంత్రం',
      'mantra': 'శ్రీ రామ జయ రామ జయ జయ రామ',
      'deity': 'శ్రీరాముడు',
    },
    {
      'name': 'హరే కృష్ణ మహా మంత్రం',
      'mantra': 'హరే కృష్ణ హరే కృష్ణ కృష్ణ కృష్ణ హరే హరే | హరే రామ హరే రామ రామ రామ హరే హరే',
      'deity': 'శ్రీకృష్ణుడు',
    },
  ];

  int _selectedMantraIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadJapaStats();
  }

  Future<void> _loadJapaStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalJapaCount = prefs.getInt('total_japa_count') ?? 0;
      _completedMalas = _totalJapaCount ~/ 108;
      _currentBead = _totalJapaCount % 108;
    });
  }

  Future<void> _incrementBead() async {
    // Tactile haptic feedback on each bead
    HapticFeedback.lightImpact();

    setState(() {
      _currentBead++;
      _totalJapaCount++;

      if (_currentBead >= 108) {
        _currentBead = 0;
        _completedMalas++;
        // Heavy celebratory haptic on completing a full Mala (108)
        HapticFeedback.heavyImpact();
        _showMalaCompletedDialog();
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_japa_count', _totalJapaCount);
  }

  void _showMalaCompletedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Text('📿 '),
            Text('108 మాల సంపూర్ణం!', style: TextStyle(color: AppTypography.primaryMaroon, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'మీరు ఒక సంపూర్ణ 108 జపమాలను పూర్తి చేశారు. మొత్తం మాలలు: $_completedMalas.\nభగవత్ కృపా కటాక్ష సిద్ధిరస్తు!',
          style: const TextStyle(fontSize: 14.5, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppTypography.primaryMaroon),
            child: const Text('ధన్యవాదాలు', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetCurrentMala() {
    setState(() {
      _currentBead = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedMantra = _mantras[_selectedMantraIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      appBar: AppBar(
        title: const Text('డిజిటల్ 108 జపమాల', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'మాల రీసెట్',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('ప్రస్తుత మాల రీసెట్ చేయాలా?'),
                  content: const Text('ప్రస్తుత మాల సంఖ్య 0 కి రీసెట్ అవుతుంది. (మొత్తం చరిత్ర మారదు)'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('వద్దు')),
                    ElevatedButton(
                      onPressed: () {
                        _resetCurrentMala();
                        Navigator.pop(ctx);
                      },
                      child: const Text('రీసెట్'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mantra Selector Dropdown Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.amber.shade50,
            child: Row(
              children: [
                const Icon(Icons.auto_stories, color: AppTypography.primaryMaroon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedMantraIndex,
                      isExpanded: true,
                      items: _mantras.asMap().entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(
                            '${entry.value['name']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTypography.primaryMaroon),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedMantraIndex = val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Total Japa Stats Ribbon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text('పూర్తయిన మాలలు', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('$_completedMalas', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text('మొత్తం జపాలు', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('$_totalJapaCount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTypography.templeDeepOrange)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active Mantra Chanting Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTypography.cardBorder),
                boxShadow: [
                  BoxShadow(color: Colors.amber.shade900.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                selectedMantra['mantra']!,
                style: AppTypography.teluguSloka(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const Spacer(),

          // Giant Interactive Japa Bead Dial
          GestureDetector(
            onTap: _incrementBead,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFFBEB),
                border: Border.all(color: AppTypography.sacredGold, width: 6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade800.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Progress Indicator around bead
                  SizedBox(
                    width: 208,
                    height: 208,
                    child: CircularProgressIndicator(
                      value: _currentBead / 108.0,
                      strokeWidth: 5,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTypography.templeDeepOrange),
                      backgroundColor: Colors.amber.shade100,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.touch_app_rounded, color: AppTypography.primaryMaroon, size: 30),
                      const SizedBox(height: 4),
                      Text(
                        '$_currentBead',
                        style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon, height: 1.0),
                      ),
                      const Text(
                        '108 లో',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'ట్యాప్ చేయండి',
                        style: TextStyle(fontSize: 11, color: AppTypography.templeDeepOrange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Bottom advice
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'ప్రతి ట్యాప్‌కు హ్యాప్టిక్ వైబ్రేషన్ అనుభూతి లభిస్తుంది • 108 కాగానే మాల పూర్తవుతుంది.',
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
