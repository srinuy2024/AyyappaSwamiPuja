import 'package:flutter/material.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../services/panchangam_service.dart';
import '../constants/app_typography.dart';
import 'puja_player_screen.dart';

/// యాప్ హోమ్ స్క్రీన్ (Devotional Dashboard & Deity Selector)
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DevoteeProfile _profile = DevoteeProfile();
  late PanchangamData _panchang;

  final List<Map<String, dynamic>> _deities = [
    {
      'id': 'ayyappa',
      'name_te': 'శ్రీ అయ్యప్పస్వామి',
      'name_sa': 'श्री अय्यप्पस्वामी',
      'icon': '🪔',
      'desc': 'హరిహరపుత్ర ధర్మశాస్తా నిత్య పూజ',
      'color': Color(0xFFE65100),
    },
    {
      'id': 'ganapathi',
      'name_te': 'శ్రీ మహాగణపతి',
      'name_sa': 'श्री महागणाधिपतिः',
      'icon': '🐘',
      'desc': 'సర్వవిఘ్న నివారక ప్రథమ పూజ',
      'color': Color(0xFFC62828),
    },
    {
      'id': 'shiva',
      'name_te': 'పరమశివుడు',
      'name_sa': 'श्री साम्बसदाशिवः',
      'icon': '🔱',
      'desc': 'మహాదేవ లింగేశ్వర షోడశోపచార పూజ',
      'color': Color(0xFF00695C),
    },
    {
      'id': 'venkateswara',
      'name_te': 'శ్రీ వేంకటేశ్వర స్వామి',
      'name_sa': 'श्री वेङ्कटेश्वर स्वामी',
      'icon': '🏹',
      'desc': 'కలియుగ ప్రత్యక్ష దైవ శ్రీనివాస పూజ',
      'color': Color(0xFF1565C0),
    },
    {
      'id': 'subramanya',
      'name_te': 'శ్రీ సుబ్రహ్మణ్యేశ్వరుడు',
      'name_sa': 'श्री सुब्रह्मण्येश्वर स्वामी',
      'icon': '🦚',
      'desc': 'శరవణభవ కార్తికేయ పూజ',
      'color': Color(0xFFAD1457),
    },
    {
      'id': 'lakshmi',
      'name_te': 'శ్రీ మహాలక్ష్మీ దేవి',
      'name_sa': 'श्री महालक्ष्मी देवी',
      'icon': '🌸',
      'desc': 'అష్టైశ్వర్య ప్రదాయిని వ్రత పూజ',
      'color': Color(0xFFF57F17),
    },
    {
      'id': 'durga',
      'name_te': 'శ్రీ దుర్గా భవానీ',
      'name_sa': 'श्री दुर्गा भवानी',
      'icon': '🌺',
      'desc': 'దుర్గతి నాశిని నవరాత్రి పూజ',
      'color': Color(0xFFB71C1C),
    },
    {
      'id': 'anjaneya',
      'name_te': 'శ్రీ ఆంజనేయ స్వామి',
      'name_sa': 'श्री आञ्जनेय स्वामी',
      'icon': '🐒',
      'desc': 'వాయుపుత్ర వీర హనుమాన్ పూజ',
      'color': Color(0xFFE65100),
    },
  ];

  @override
  void initState() {
    super.initState();
    _panchang = PanchangamService.calculate(DateTime.now());
  }

  void _startPujaForDeity(String deityId, String nameTe, String nameSa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PujaPlayerScreen(
          devoteeProfile: _profile,
          deityId: deityId,
          deityNameTe: nameTe,
          deityNameSa: nameSa,
        ),
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
        title: const Text('భక్తుని కుటుంబ వివరాలు (Edit Profile)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: gotraController, decoration: const InputDecoration(labelText: 'గోత్రం')),
              TextField(controller: kartaController, decoration: const InputDecoration(labelText: 'కర్త పేరు')),
              TextField(controller: spouseController, decoration: const InputDecoration(labelText: 'ధర్మపత్ని పేరు')),
              TextField(controller: childrenController, decoration: const InputDecoration(labelText: 'సంతానం పేర్లు')),
              TextField(controller: pincodeController, decoration: const InputDecoration(labelText: 'పిన్‌కోడ్ (Pincode)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('రద్దు')),
          ElevatedButton(
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
        elevation: 0,
        title: Row(
          children: const [
            Text('🕉️ ', style: TextStyle(fontSize: 22)),
            Text('సర్వ దేవతా పూజా మందిరం', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'ప్రొఫైల్ వివరాలు',
            onPressed: _showProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Devotee Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTypography.primaryMaroon, AppTypography.templeDeepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'నమస్కారము స్వామి! 🙏',
                        style: AppTypography.teluguSloka(fontSize: 18, color: Colors.amber.shade200),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                        onPressed: _showProfileDialog,
                      ),
                    ],
                  ),
                  Text(
                    '${_profile.gotram} గోత్రోద్భవులైన ${_profile.kartaName} & ${_profile.spouseName} దంపతులు',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'పుత్రౌ: ${_profile.childrenNames} | ప్రాంతం: ${_profile.city} (${_profile.pincode})',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Live Panchangam Glance Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('📅 ', style: TextStyle(fontSize: 18)),
                      Text('నేటి ప్రత్యక్ష పంచాంగం (Live Panchangam)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    'శ్రీ ${_panchang.samvatsaraTe} సంవత్సరం | ${_panchang.ayanaTe} | ${_panchang.masaTe} మాసం',
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF78350F)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'తిథి: ${_panchang.tithiTe} (${_panchang.pakshaTe}) | వారం: ${_panchang.vasaraTe} | నక్షత్రం: ${_panchang.nakshatraTe}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF92400E)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Quick Start Prominent Action Button
            ElevatedButton.icon(
              onPressed: () => _startPujaForDeity('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय्यप्पस्वामी'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTypography.templeDeepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
              ),
              icon: const Text('⚡', style: TextStyle(fontSize: 24)),
              label: const Text(
                'నేటి నిత్య పూజ ప్రారంభించండి (15 ని॥ గైడెడ్)',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Section Title: Choose Deity
            Text(
              '🌟 ఇష్టదేవతను ఎంచుకోండి (Select Deity)',
              style: AppTypography.sacredHeader(fontSize: 19),
            ),
            const SizedBox(height: 12),

            // 5. Grid of Deities
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _deities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                var d = _deities[index];
                return InkWell(
                  onTap: () => _startPujaForDeity(d['id'], d['name_te'], d['name_sa']),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(d['icon'], style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 6),
                        Text(
                          d['name_te'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: AppTypography.primaryMaroon),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d['desc'],
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // 6. Public Domain Citations Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('📜 సమాచార మూలాలు & కృతజ్ఞతలు (Public Domain Citations):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Color(0xFF78350F))),
                  SizedBox(height: 4),
                  Text('• పిన్‌కోడ్ & నగరాలు: Open Government Data (data.gov.in) - GODL India', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  Text('• పంచాంగం: ద్రిక-సిద్ధాంతం & Jean Meeus / Moshier Ephemeris (MIT License)', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  Text('• స్తోత్రాలు: SanskritDocuments.org & తెలుగు వికీసోర్స్ (Public Domain CC0 / CC-BY)', style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
