// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_typography.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../services/panchangam_service.dart';
import '../widgets/sacred_glass_card.dart';
import '../widgets/sankalpam_panchang_box.dart';
import 'suprabhatam_screen.dart';
import 'jnana_library_screen.dart';

/// ఆలయ గర్భగుడి హోమ్ స్క్రీన్ (Living Transparent 3D Temple Sanctum & 4-Yoga Portals)
class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  const HomeScreen({Key? key, this.onNavigateToTab}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DevoteeProfile _profile = DevoteeProfile();
  late PanchangamData _panchang;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _panchang = PanchangamService.calculate(_selectedDate);
    DevoteeProfile.loadFromPrefs().then((p) {
      if (mounted) setState(() => _profile = p);
    });
  }

  Future<void> _selectPanchangDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _panchang = PanchangamService.calculate(_selectedDate);
      });
    }
  }

  void _resetPanchangDate() {
    setState(() {
      _selectedDate = DateTime.now();
      _panchang = PanchangamService.calculate(_selectedDate);
    });
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

  void _openSuprabhatamScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuprabhatamScreen()),
    );
  }

  void _shareDailyStatusCard() {
    HapticFeedback.mediumImpact();
    final dateStr = '${_selectedDate.day.toString().padLeft(2, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.year}';
    final shareText = '''🛕 శ్రీ పూజా మందిరం • నేటి శుభోదయ సందేశం 🙏
📅 తేది: $dateStr
✨ తిథి: ${_panchang.tithiTe}
🌟 నక్షత్రం: ${_panchang.nakshatraTe}
⏰ అభిజిత్ ముహూర్తం: 11:45 AM - 12:30 PM
⚠️ రాహుకాలం: 03:00 PM - 04:30 PM

📜 నేటి దిన శ్లోకం (భగవద్గీత 2.47):
కర్మణ్యేవాధికారస్తే మా ఫలేషు కదాచన |
మా కర్మఫలహేతుర్భూర్మా తే సఙ్గోఽస్త్వకర్మణి ||
💡 భావం: కర్తవ్యాన్ని నిష్కామంగా నిర్వహించు; ఫలితంపై ఆందోళన వదిలేసి మనశ్శాంతిని పొందు.

🌸 లోకాః సమస్తాః సుఖినో భవంతు! 🪔
సర్వ దేవతా నిత్య పూజలు & వ్రతాల వేదిక:
https://github.com/srinuy2024/AyyappaSwamiPuja''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ నేటి శుభోదయ సందేశం కాపీ చేయబడింది! వాట్సాప్‌లో బంధుమిత్రులకు షేర్ చేయండి!'),
        backgroundColor: Color(0xFF059669),
        duration: Duration(seconds: 3),
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
        title: const Text('భక్తుని కుటుంబ వివరాలు (Family Profile)', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: gotraController, decoration: const InputDecoration(labelText: 'గోత్రం (Gotram)')),
              TextField(controller: kartaController, decoration: const InputDecoration(labelText: 'గృహస్థు / కర్త పేరు')),
              TextField(controller: spouseController, decoration: const InputDecoration(labelText: 'ధర్మపత్ని పేరు')),
              TextField(controller: childrenController, decoration: const InputDecoration(labelText: 'సంతానం పేర్లు')),
              TextField(controller: pincodeController, decoration: const InputDecoration(labelText: 'పిన్‌కోడ్ / నగరం')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('రద్దు')),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _profile.gotram = gotraController.text.trim();
                _profile.kartaName = kartaController.text.trim();
                _profile.spouseName = spouseController.text.trim();
                _profile.childrenNames = childrenController.text.trim();
                _profile.pincode = pincodeController.text.trim();
              });
              await _profile.saveToPrefs();
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('భద్రపరచు'),
          ),
        ],
      ),
    );
  }

  Widget _build3DAssetImage(String assetName, {double size = 64}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/3d/$assetName.webp',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) {
            return Image.asset(
              'assets/images/3d/$assetName.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: size,
                height: size,
                color: Colors.amber.shade100,
                alignment: Alignment.center,
                child: const Icon(Icons.temple_hindu, color: AppTypography.sacredGold),
              ),
            );
          },
        ),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade300.withValues(alpha: 0.8), width: 1.0),
          boxShadow: [
            BoxShadow(color: Colors.amber.shade900.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
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

  /// 3D యోగ ద్వారం కార్డ్ (Transparent 3D Yoga Chamber Portal with Real 3D Image)
  Widget _build3DYogaPortal({
    required String title,
    required String subtitle,
    required String visualItems,
    required String assetImageName,
    required Color accentColor,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return SacredGlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      borderColor: accentColor.withValues(alpha: 0.5),
      child: Row(
        children: [
          _build3DAssetImage(assetImageName, size: 66),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        actionLabel,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  visualItems,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 15, color: accentColor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      appBar: AppBar(
        backgroundColor: AppTypography.primaryMaroon,
        foregroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: const [
            Text('🛕 ', style: TextStyle(fontSize: 22)),
            Text(
              'పూజా మందిరం',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
      body: Stack(
        children: [
          // 1. Ambient Golden-Temple Radiant Backdrop (Gives true glass depth)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFEF3C7), // Warm morning sanctum gold
                    Color(0xFFFFF7ED), // Saffron amber glow
                    Color(0xFFFDE68A), // Divine brass reflection
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.shade300.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            top: 320,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEA580C).withValues(alpha: 0.12),
              ),
            ),
          ),

          // 2. Scrollable Transparent 3D Glass Layer
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Devotee Family Profile Glass Bar
                SacredGlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  borderColor: Colors.white.withValues(alpha: 0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text('🙏 ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                '${_profile.gotram} గోత్రం • ${_profile.kartaName} & ${_profile.spouseName}',
                                style: const TextStyle(
                                  color: AppTypography.primaryMaroon,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _showProfileDialog,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTypography.primaryMaroon.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTypography.primaryMaroon.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.edit, size: 12, color: AppTypography.primaryMaroon),
                              SizedBox(width: 4),
                              Text('సవరించు', style: TextStyle(color: AppTypography.primaryMaroon, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Centerpiece: Living 3D Temple Sanctum & Soundboard (ఆలయ గర్భగుడి దర్శనం)
                SacredGlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  borderColor: AppTypography.sacredGold.withValues(alpha: 0.7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3D Miniature Temple Sanctum Hero Image Banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/3d/temple_sanctum_3d.webp',
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Image.asset(
                                'assets/images/3d/temple_sanctum_3d.png',
                                width: double.infinity,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  width: double.infinity,
                                  height: 140,
                                  color: AppTypography.primaryMaroon,
                                  child: const Icon(Icons.temple_hindu, size: 48, color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTypography.sacredGold, width: 0.8),
                                ),
                                child: const Text('✨ లైవ్ గర్భగుడి', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A))),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                                  ),
                                ),
                                child: const Text(
                                  'సజీవ 3D గర్భగుడి దర్శనం & దివ్య ధ్వనులు',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Soundboard Instruments
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

                // 3. Live Panchangam & Muhurtham Glass Card
                SacredGlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  borderColor: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      SankalpamPanchangBox(
                        panchang: _panchang,
                        profile: _profile,
                        selectedDate: _selectedDate,
                        onSelectDate: _selectPanchangDate,
                        onResetDate: _resetPanchangDate,
                        onEditProfile: _showProfileDialog,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('✨ అభిజిత్ ముహూర్తం: 11:45 AM - 12:30 PM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                            Text('⚠️ రాహుకాలం: 03:00 - 04:30 PM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Sloka of the Day Glass Card (నేటి దిన శ్లోకం & WhatsApp Share)
                SacredGlassCard(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Text('📜 ', style: TextStyle(fontSize: 15)),
                              Text(
                                'నేటి దిన శ్లోకం (భగవద్గీత 2.47)',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTypography.primaryMaroon),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.onNavigateToTab != null) {
                                widget.onNavigateToTab!(2);
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const JnanaLibraryScreen()));
                              }
                            },
                            child: const Text('జ్ఞాన నిధి >', style: TextStyle(fontSize: 11.5, color: AppTypography.templeDeepOrange, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'కర్మణ్యేవాధికారస్తే మా ఫలేషు కదాచన | మా కర్మఫలహేతుర్భూర్మా తే సఙ్గోఽస్త్వకర్మణి ||',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.3),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'తాత్పర్యం: పనిని కర్తవ్యంగా చెయ్యి; ఫలితంపై ఆందోళన వదిలేసి మనశ్శాంతిని పొందు.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _shareDailyStatusCard,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF15803D),
                            side: const BorderSide(color: Color(0xFF86EFAC), width: 1.2),
                            backgroundColor: const Color(0xFFF0FDF4).withValues(alpha: 0.9),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Text('📲', style: TextStyle(fontSize: 16)),
                          label: const Text(
                            'నేటి శుభోదయ సందేశం వాట్సాప్‌లో షేర్ చేయండి',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 5. Section Header: చతుర్విధ యోగ స్వర్ణ ద్వారాలు (The 4 Sacred 3D Portals)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
                  child: Row(
                    children: const [
                      Text('🌟 ', style: TextStyle(fontSize: 18)),
                      Text(
                        'చతుర్విధ యోగ మార్గాలు (4 Sacred Portals)',
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon),
                      ),
                    ],
                  ),
                ),

                // Portal 1: కర్మ యోగం (Karma Chamber with 3D Kalasham)
                _build3DYogaPortal(
                  title: 'కర్మ యోగం',
                  subtitle: 'పూజలు, వ్రతాలు & సంకల్పం',
                  visualItems: 'స్వర్ణ కలశం, కొబ్బరికాయ, పవిత్ర పీఠం',
                  assetImageName: 'karma_kalasham_3d',
                  accentColor: const Color(0xFFB91C1C),
                  actionLabel: 'ప్రవేశించండి',
                  onTap: () => widget.onNavigateToTab != null ? widget.onNavigateToTab!(1) : null,
                ),

                // Portal 2: భక్తి యోగం (Bhakti Chamber with 3D Harati & Bell)
                _build3DYogaPortal(
                  title: 'భక్తి యోగం',
                  subtitle: 'సుప్రభాతాలు, భజనలు & స్తుతులు',
                  visualItems: 'కర్పూర హారతి జ్యోతి, కంచు గంట, తామర పూలు',
                  assetImageName: 'bhakti_harati_3d',
                  accentColor: const Color(0xFFD97706),
                  actionLabel: 'దర్శించండి',
                  onTap: _openSuprabhatamScreen,
                ),

                // Portal 3: జ్ఞాన యోగం (Jnana Chamber with 3D Bhagavad Gita)
                _build3DYogaPortal(
                  title: 'జ్ఞాన యోగం',
                  subtitle: 'భగవద్గీత, వేదాలు & పురాణాలు',
                  visualItems: 'స్వర్ణ తాళపత్ర గ్రంథం, శాంతి మంత్రాలు',
                  assetImageName: 'jnana_gita_3d',
                  accentColor: const Color(0xFF0D9488),
                  actionLabel: 'చదవండి',
                  onTap: () => widget.onNavigateToTab != null ? widget.onNavigateToTab!(2) : null,
                ),

                // Portal 4: ధ్యాన యోగం (Dhyana Chamber with 3D 108 Rudraksha Mala)
                _build3DYogaPortal(
                  title: 'ధ్యాన యోగం',
                  subtitle: '108 జపమాల & మండల దీక్షా సాధన',
                  visualItems: 'రుద్రాక్ష జపమాల, ధ్యాన ముద్ర & అంతఃశాంతి',
                  assetImageName: 'dhyana_mala_3d',
                  accentColor: const Color(0xFF7C3AED),
                  actionLabel: 'సాధన చేయండి',
                  onTap: () => widget.onNavigateToTab != null ? widget.onNavigateToTab!(3) : null,
                ),

                const SizedBox(height: 8),

                // Quick Banner to Pujas Hub
                SacredGlassCard(
                  onTap: () => widget.onNavigateToTab != null ? widget.onNavigateToTab!(1) : null,
                  borderColor: AppTypography.sacredGold.withValues(alpha: 0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('🛕 ', style: TextStyle(fontSize: 16)),
                      Text(
                        'సకల దేవతా పూజలు & వ్రతాల వేదికకు వెళ్ళండి >',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTypography.primaryMaroon),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
