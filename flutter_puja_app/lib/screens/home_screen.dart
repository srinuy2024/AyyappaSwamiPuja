import 'package:flutter/material.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../services/panchangam_service.dart';
import '../services/deity_puja_data_service.dart';
import '../constants/app_typography.dart';
import 'puja_player_screen.dart';
import 'ayyappa_deeksha_screen.dart';
import 'package:flutter/services.dart';
import 'suprabhatam_screen.dart';
import 'vratam_player_screen.dart';
import 'japa_mala_screen.dart';
import 'jnana_library_screen.dart';
import '../services/auto_update_service.dart';
import '../widgets/sankalpam_panchang_box.dart';

/// యాప్ హోమ్ స్క్రీన్ (Devotional Dashboard, Live Panchangam & Deity Puja Selector)
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DevoteeProfile _profile = DevoteeProfile();
  late PanchangamData _panchang;
  DateTime _selectedDate = DateTime.now();

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
    // Load persisted devotee family profile
    DevoteeProfile.loadFromPrefs().then((loadedProfile) {
      if (mounted) {
        setState(() {
          _profile = loadedProfile;
        });
      }
    });
    // Auto-update check in background (100% safe offline)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AutoUpdateService.checkForUpdate().then((info) {
        if (info != null && mounted) {
          AutoUpdateService.showUpdateDialog(context, info);
        }
      });
    });
  }

  void _openSuprabhatamScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuprabhatamScreen(),
      ),
    );
  }

  Future<void> _selectPanchangDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'పంచాంగ పూజా తేదీని ఎంచుకోండి (Select Puja Date)',
      confirmText: 'నిర్ణయించు',
      cancelText: 'రద్దు',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _panchang = PanchangamService.calculate(picked);
      });
    }
  }

  void _resetPanchangDate() {
    setState(() {
      _selectedDate = DateTime.now();
      _panchang = PanchangamService.calculate(_selectedDate);
    });
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
          initialPanchang: _panchang,
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

  void _openVratamScreen(String vratamId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VratamPlayerScreen(vratamId: vratamId),
      ),
    );
  }

  void _openJapaMalaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JapaMalaScreen(),
      ),
    );
  }

  void _openJnanaLibraryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JnanaLibraryScreen(),
      ),
    );
  }

  void _ringTempleBell() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔔 ఆగమార్ధంచ దేవానాం గమనార్థంచ రక్షసాం - ఆలయ కంచు ఘంటానాదం!'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTypography.primaryMaroon,
      ),
    );
  }

  void _blowConch() {
    HapticFeedback.vibrate();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🐚 ఓం పాంచజన్యాయ నమః - మంగళకరమైన దివ్య శంఖధ్వని!'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTypography.templeDeepOrange,
      ),
    );
  }

  void _lightDiya() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🪔 దీపజ్యోతిః పరబ్రహ్మ దీపజ్యోతిర్జనార్దనః - నిత్య దీపారాధన!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFD97706),
      ),
    );
  }

  void _showerFlowers() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🌸 నానావిధ పరిమళ పత్ర పుష్పాణి సమర్పయామి!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  Widget _buildSoundboardItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber.shade300, width: 1.0),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: AppTypography.primaryMaroon),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 9.5, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYogaPill({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 8.5, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
              const SizedBox(height: 14),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.system_update_alt, color: AppTypography.primaryMaroon),
                title: const Text('అప్‌డేట్స్ తనిఖీ చేయండి (Check Updates)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('వెర్షన్: v${AutoUpdateService.currentVersion} • 100% ఆఫ్‌లైన్ సేఫ్', style: const TextStyle(fontSize: 11.5)),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AutoUpdateService.checkForUpdate().then((info) {
                      if (info != null) {
                        AutoUpdateService.showUpdateDialog(context, info);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('మీరు తాజా వెర్షన్ (v${AutoUpdateService.currentVersion}) వాడుతున్నారు! ఎటువంటి అప్‌డేట్ అవసరం లేదు.'),
                            backgroundColor: AppTypography.primaryMaroon,
                          ),
                        );
                      }
                    });
                  },
                  child: const Text('చెక్ చేయి'),
                ),
              ),
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
            onPressed: () async {
              setState(() {
                _profile.gotram = gotraController.text;
                _profile.kartaName = kartaController.text;
                _profile.spouseName = spouseController.text;
                _profile.childrenNames = childrenController.text;
                _profile.pincode = pincodeController.text;
              });
              await _profile.saveToPrefs();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('భక్తుని వివరాలు శాశ్వతంగా భద్రపరచబడ్డాయి!'),
                    backgroundColor: Color(0xFF15803D),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
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
        foregroundColor: Colors.white,
        elevation: 3,
        title: Row(
          children: const [
            Text('🪔 ', style: TextStyle(fontSize: 22)),
            Text(
              'పూజా మందిరం',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Colors.white,
              ),
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
            // 1. Devotee Family Bar
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
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
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFDE68A), width: 0.8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.edit, size: 13, color: Color(0xFFFDE68A)),
                          SizedBox(width: 4),
                          Text(
                            'సవరించు',
                            style: TextStyle(
                              color: Color(0xFFFDE68A),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 1.5 Dedicated Proper Sankalpam & Panchangam Box
            SankalpamPanchangBox(
              panchang: _panchang,
              profile: _profile,
              selectedDate: _selectedDate,
              onSelectDate: _selectPanchangDate,
              onResetDate: _resetPanchangDate,
              onEditProfile: _showProfileDialog,
            ),

            // 1.6 Temple Sanctum Interactive Soundboard (గర్భగుడి & శబ్దాల బోర్డు)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200, width: 1.2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text('🛕 ', style: TextStyle(fontSize: 16)),
                          Text(
                            'ఆలయ గర్భగుడి దర్శనం & శబ్దాల బోర్డు',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTypography.primaryMaroon),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('లైవ్ టెంపుల్', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSoundboardItem(
                        icon: '🔔',
                        title: 'కంచు గంట',
                        subtitle: 'ఘంటానాదం',
                        onTap: _ringTempleBell,
                      ),
                      _buildSoundboardItem(
                        icon: '🐚',
                        title: 'దివ్య శంఖం',
                        subtitle: 'శంఖధ్వని',
                        onTap: _blowConch,
                      ),
                      _buildSoundboardItem(
                        icon: '🪔',
                        title: 'దీపారాధన',
                        subtitle: 'నిత్య జ్యోతి',
                        onTap: _lightDiya,
                      ),
                      _buildSoundboardItem(
                        icon: '🌸',
                        title: 'పుష్పార్చన',
                        subtitle: 'పూల వర్షం',
                        onTap: _showerFlowers,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 1.7 Today's Auspicious Timings & Rahu Kalam Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Text('✨ ', style: TextStyle(fontSize: 14)),
                            Text('అభిజిత్ ముహూర్తం: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFB45309))),
                            Text('11:45 AM - 12:30 PM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF15803D))),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text('⚠️ ', style: TextStyle(fontSize: 14)),
                            Text('రాహుకాలం (వర్జ్యం): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFB45309))),
                            Text('03:00 PM - 04:30 PM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFDC2626))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('శుభ సమయం\n11:45 AM', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                  ),
                ],
              ),
            ),

            // 1.8 Sloka of the Day Card (నేటి దిన శ్లోకం)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTypography.cardBorder),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text('📜 ', style: TextStyle(fontSize: 14)),
                          Text(
                            'నేటి దిన శ్లోకం (భగవద్గీత 2.47)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTypography.primaryMaroon),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _openJnanaLibraryScreen,
                        child: const Text('మరిన్ని >', style: TextStyle(fontSize: 11.5, color: AppTypography.templeDeepOrange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'కర్మణ్యేవాధికారస్తే మా ఫలేషు కదాచన | మా కర్మఫలహేతుర్భూర్మా తే సఙ్గోఽస్త్వకర్మణి ||',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.3),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'తాత్పర్యం: పనిని కర్తవ్యంగా చెయ్యి; ఫలితంపై ఆందోళన వదిలేసి మనశ్శాంతిని పొందు.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),

            // 1.9 Section Title: The 4 Divine Yogas (చతుర్విధ యోగ మార్గాలు)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Text('🌟 ', style: TextStyle(fontSize: 18)),
                  Text(
                    'చతుర్విధ యోగ మార్గాలు (4 Divine Paths)',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTypography.primaryMaroon,
                    ),
                  ),
                ],
              ),
            ),

            // 4 Yogas Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  // Karma Yoga
                  Expanded(
                    child: _buildYogaPill(
                      title: 'కర్మ యోగం',
                      subtitle: 'పూజలు & వ్రతాలు',
                      icon: Icons.temple_hindu,
                      color: const Color(0xFFB91C1C),
                      onTap: () => _openVratamScreen('satyanarayana_vratam'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bhakti Yoga
                  Expanded(
                    child: _buildYogaPill(
                      title: 'భక్తి యోగం',
                      subtitle: 'భజనలు & స్తుతులు',
                      icon: Icons.volunteer_activism,
                      color: const Color(0xFFD97706),
                      onTap: _openSuprabhatamScreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Jnana Yoga
                  Expanded(
                    child: _buildYogaPill(
                      title: 'జ్ఞాన యోగం',
                      subtitle: 'భగవద్గీత & వేదాలు',
                      icon: Icons.menu_book,
                      color: const Color(0xFF0D9488),
                      onTap: _openJnanaLibraryScreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dhyana Yoga
                  Expanded(
                    child: _buildYogaPill(
                      title: 'ధ్యాన యోగం',
                      subtitle: '108 జపమాల',
                      icon: Icons.self_improvement,
                      color: const Color(0xFF7C3AED),
                      onTap: _openJapaMalaScreen,
                    ),
                  ),
                ],
              ),
            ),

            // 1.95 Dedicated Self-Guided Satyanarayana Vratam Banner (Karma Yoga Feature)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: InkWell(
                onTap: () => _openVratamScreen('satyanarayana_vratam'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF991B1B), Color(0xFFB91C1C)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                    boxShadow: [
                      BoxShadow(color: Colors.red.shade900.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('🪔', style: TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'శ్రీ సత్యనారాయణ స్వామి సంపూర్ణ వ్రతం',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'సామగ్రి చెక్‌లిస్ట్ • పూజా విధానం • సంపూర్ణ 5 అధ్యాయాల కథ',
                              style: TextStyle(fontSize: 12, color: Color(0xFFFDE68A)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFDE68A)),
                    ],
                  ),
                ),
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

            // 2.5 Dedicated Suprabhatam Suite Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: InkWell(
                onTap: _openSuprabhatamScreen,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade200.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('🌅', style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'సర్వ దేవతా సుప్రభాత నిధి',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTypography.primaryMaroon,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'వేంకటేశ్వర • అయ్యప్ప • శివ • గణపతి సుప్రభాతాలు & కరదర్శనం',
                              style: TextStyle(fontSize: 12.5, color: AppTypography.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: AppTypography.primaryMaroon),
                    ],
                  ),
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
