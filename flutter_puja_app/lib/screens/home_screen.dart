import 'package:flutter/material.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../services/panchangam_service.dart';
import '../services/deity_puja_data_service.dart';
import '../constants/app_typography.dart';
import 'puja_player_screen.dart';
import 'ayyappa_deeksha_screen.dart';

/// యాప్ హోమ్ స్క్రీన్ (Devotional Dashboard, Live Panchangam & Deity Puja Selector)
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DevoteeProfile _profile = DevoteeProfile();
  late PanchangamData _panchang;

  final List<Map<String, dynamic>> _deitiesList = [
    {
      'id': 'ayyappa',
      'name_te': 'శ్రీ అయ్యప్పస్వామి',
      'name_sa': 'श्री अय्यप्पस्वामी',
      'icon': '🪔',
      'desc': 'హరిహరపుత్ర ధర్మశాస్తా మండల దీక్షా పూజ',
      'color': Color(0xFFC2410C),
      'is_hero': true,
    },
    {
      'id': 'ganapathi',
      'name_te': 'శ్రీ మహాగణపతి',
      'name_sa': 'श्री महागणाधिपतिः',
      'icon': '🐘',
      'desc': 'సర్వవిఘ్న నివారక ప్రథమ పూజ',
      'color': Color(0xFFB91C1C),
    },
    {
      'id': 'shiva',
      'name_te': 'పరమశివుడు (సాంబసదాశివుడు)',
      'name_sa': 'श्री साम्बसदाशिवः',
      'icon': '🔱',
      'desc': 'మహాదేవ కైలాసపతి లింగేశ్వర పూజ',
      'color': Color(0xFF0F766E),
    },
    {
      'id': 'venkateswara',
      'name_te': 'శ్రీ వేంకటేశ్వర స్వామి',
      'name_sa': 'श्री वेङ्कटेश्वर स्वामी',
      'icon': '🏹',
      'desc': 'కలియుగ ప్రత్యక్ష దైవ శ్రీనివాస పూజ',
      'color': Color(0xFF1D4ED8),
    },
    {
      'id': 'subramanya',
      'name_te': 'శ్రీ సుబ్రహ్మణ్యేశ్వరుడు',
      'name_sa': 'श्री सुब्रह्मण्येश्वर स्वामी',
      'icon': '🦚',
      'desc': 'శరవణభవ కార్తికేయ సేనాపతి పూజ',
      'color': Color(0xFF9D174D),
    },
    {
      'id': 'lakshmi',
      'name_te': 'శ్రీ మహాలక్ష్మీ దేవి',
      'name_sa': 'श्री महालक्ष्मी देवी',
      'icon': '🌸',
      'desc': 'అష్టైశ్వర్య ప్రదాయిని వరలక్ష్మీ పూజ',
      'color': Color(0xFFB45309),
    },
    {
      'id': 'durga',
      'name_te': 'శ్రీ దుర్గా భవానీ (కనకదుర్గ)',
      'name_sa': 'श्री दुर्गा भवानी',
      'icon': '🌺',
      'desc': 'దుర్గతినాశిని మహిషాసురమర్దిని పూజ',
      'color': Color(0xFF991B1B),
    },
    {
      'id': 'anjaneya',
      'name_te': 'శ్రీ ఆంజనేయ స్వామి',
      'name_sa': 'श्री आञ्जनेय स्वामी',
      'icon': '🐒',
      'desc': 'వాయుపుత్ర వీర హనుమాన్ సంకటమోచన పూజ',
      'color': Color(0xFFC2410C),
    },
    {
      'id': 'saraswati',
      'name_te': 'శ్రీ సరస్వతీ దేవి',
      'name_sa': 'श्री सरस्वती देवी',
      'icon': '📖',
      'desc': 'విద్యాబుద్ధి ప్రదాయిని జ్ఞాన సరస్వతి పూజ',
      'color': Color(0xFF0369A1),
    },
  ];

  @override
  void initState() {
    super.initState();
    _panchang = PanchangamService.calculate(DateTime.now());
  }

  void _startPujaForDeity(String deityId, String nameTe, String nameSa, bool isFullMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PujaPlayerScreen(
          devoteeProfile: _profile,
          deityId: deityId,
          deityNameTe: nameTe,
          deityNameSa: nameSa,
          initialIsFullMode: isFullMode,
        ),
      ),
    );
  }

  void _openAyyappaDeekshaHub() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AyyappaDeekshaScreen(),
      ),
    );
  }

  Widget _buildDeityAvatar(String deityId, String icon, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        'assets/images/deities/$deityId.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/deities/$deityId.jpg',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, st) {
              return Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                child: Text(icon, style: TextStyle(fontSize: size * 0.52)),
              );
            },
          );
        },
      ),
    );
  }

  void _showProfileDialog() {
    final gotraController = TextEditingController(text: _profile.gotram);
    final kartaController = TextEditingController(text: _profile.kartaName);
    final spouseController = TextEditingController(text: _profile.spouseName);
    final childrenController = TextEditingController(text: _profile.childrenNames);
    final pincodeController = TextEditingController(text: _profile.pincode);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('భక్తుని కుటుంబ వివరాలు (Edit Profile)', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: gotraController, decoration: const InputDecoration(labelText: 'గోత్రం (Gotram)')),
              TextField(controller: kartaController, decoration: const InputDecoration(labelText: 'కర్త పేరు (Karta)')),
              TextField(controller: spouseController, decoration: const InputDecoration(labelText: 'ధర్మపత్ని పేరు (Spouse)')),
              TextField(controller: childrenController, decoration: const InputDecoration(labelText: 'సంతానం పేర్లు (Children)')),
              TextField(controller: pincodeController, decoration: const InputDecoration(labelText: 'పిన్‌కోడ్ (Pincode)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('రద్దు')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTypography.primaryMaroon,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _profile.gotram = gotraController.text;
                _profile.kartaName = kartaController.text;
                _profile.spouseName = spouseController.text;
                _profile.childrenNames = childrenController.text;
                _profile.pincode = pincodeController.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('సేవ్ చేయండి'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        backgroundColor: AppTypography.primaryMaroon,
        elevation: 3,
        title: Row(
          children: const [
            Text('🪔 ', style: TextStyle(fontSize: 22)),
            Text(
              'పూజా మందిరం',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'భక్తుని వివరాలు',
            onPressed: _showProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Live Panchangam & Devotee Bar
            Container(
              decoration: BoxDecoration(
                color: AppTypography.primaryMaroonDark,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Devotee names line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '🙏 ${_profile.gotram} గోత్రం • ${_profile.kartaName} & ${_profile.spouseName} (${_profile.childrenNames})',
                          style: const TextStyle(
                            color: Color(0xFFFEF3C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: _showProfileDialog,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.edit, size: 16, color: Color(0xFFFDE68A)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Dynamic Live Panchangam line
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '📅 ${_panchang.samvatsaraTe} నామ సంవత్సరం • ${_panchang.masaTe} మాసం',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTypography.sacredGold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_panchang.tithiTe} • ${_panchang.vasaraTe}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. HERO CARD: Sri Ayyappa Swamy Puja & Mandala Deeksha Hub
            Container(
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7F1D1D), Color(0xFFC2410C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade900.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(29),
                            border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: _buildDeityAvatar('ayyappa', '🪔', 56),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'శ్రీ అయ్యప్పస్వామి పూజ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'హరిహరపుత్ర ధర్మశాస్తా నిత్య & మండల దీక్షా పూజ',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFFFDE68A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick Action Buttons for Sri Ayyappa
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _startPujaForDeity('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय्यप्पस्वामी', false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTypography.primaryMaroon,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.flash_on, size: 18, color: AppTypography.vibrantOrange),
                            label: const Text(
                              'నిత్య లఘు పూజ\n(15-20 ని)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _startPujaForDeity('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय्यप्पस्वामी', true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEF3C7),
                              foregroundColor: AppTypography.primaryMaroon,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.stars, size: 18, color: AppTypography.primaryMaroon),
                            label: const Text(
                              'సంపూర్ణ షోడశ\n(35-45 ని)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dedicated Ayyappa Mandala Deeksha Hub Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openAyyappaDeekshaHub,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFFDE68A), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Text('🚩', style: TextStyle(fontSize: 18)),
                        label: const Text(
                          'అయ్యప్ప మండల దీక్షా హబ్ (18 మెట్లు, 108 శరణు, హరివరాసనం)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Section Title: All Sanatana Dharma Deities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Text('🌺 ', style: TextStyle(fontSize: 20)),
                  Text(
                    'సనాతన ధర్మ దేవతా పూజా మందిరం',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTypography.primaryMaroon,
                    ),
                  ),
                ],
              ),
            ),

            // 4. Deity Cards List (Skip Ayyappa here as he has Hero card)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
              itemCount: _deitiesList.length - 1,
              itemBuilder: (context, index) {
                final deity = _deitiesList[index + 1]; // Skip hero ayyappa
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1.5,
                  color: AppTypography.cardSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.amber.shade200, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: (deity['color'] as Color).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: deity['color'] as Color, width: 1.2),
                              ),
                              alignment: Alignment.center,
                              child: _buildDeityAvatar(deity['id'], deity['icon'], 48),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    deity['name_te'],
                                    style: const TextStyle(
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTypography.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    deity['desc'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTypography.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Mode Selection Buttons for Each Deity
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _startPujaForDeity(
                                  deity['id'],
                                  deity['name_te'],
                                  deity['name_sa'],
                                  false,
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTypography.templeDeepOrange,
                                  side: const BorderSide(color: AppTypography.templeDeepOrange, width: 1.2),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.flash_on, size: 16),
                                label: const Text('నిత్య లఘు పూజ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _startPujaForDeity(
                                  deity['id'],
                                  deity['name_te'],
                                  deity['name_sa'],
                                  true,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTypography.primaryMaroon,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.stars, size: 16),
                                label: const Text('షోడశోపచార పూజ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
