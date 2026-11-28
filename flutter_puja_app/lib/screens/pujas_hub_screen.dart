// lib/screens/pujas_hub_screen.dart
import 'package:flutter/material.dart';
import '../constants/app_typography.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../widgets/sacred_glass_card.dart';
import 'puja_player_screen.dart';
import 'vratam_player_screen.dart';

class PujasHubScreen extends StatefulWidget {
  final DevoteeProfile profile;
  final PanchangamData panchang;

  const PujasHubScreen({
    Key? key,
    required this.profile,
    required this.panchang,
  }) : super(key: key);

  @override
  State<PujasHubScreen> createState() => _PujasHubScreenState();
}

class _PujasHubScreenState extends State<PujasHubScreen> {
  final List<Map<String, dynamic>> _deitiesList = [
    {
      'id': 'ayyappa',
      'name_te': 'శ్రీ అయ్యప్పస్వామి',
      'name_sa': 'श्री अय्यप्पस्वामी',
      'icon': '🪔',
      'desc': 'హరిహరపుత్ర ధర్మశాస్తా మండల దీక్షా పూజ',
      'color': const Color(0xFFC2410C),
      'is_hero': true,
    },
    {
      'id': 'ganapathi',
      'name_te': 'శ్రీ మహాగణపతి',
      'name_sa': 'श्री महागणाधिपतिः',
      'icon': '🐘',
      'desc': 'సర్వవిఘ్న నివారక ప్రథమ పూజ',
      'color': const Color(0xFFB91C1C),
    },
    {
      'id': 'shiva',
      'name_te': 'పరమశివుడు (సాంబసదాశివుడు)',
      'name_sa': 'श्री साम्बसदाशिवः',
      'icon': '🔱',
      'desc': 'మహాదేవ కైలాసపతి లింగేశ్వర పూజ',
      'color': const Color(0xFF0F766E),
    },
    {
      'id': 'venkateswara',
      'name_te': 'శ్రీ వేంకటేశ్వర స్వామి',
      'name_sa': 'श्री वेङ्कटेश्वर स्वामी',
      'icon': '🏹',
      'desc': 'కలియుగ ప్రత్యక్ష దైవ శ్రీనివాస పూజ',
      'color': const Color(0xFF1D4ED8),
    },
    {
      'id': 'subramanya',
      'name_te': 'శ్రీ సుబ్రహ్మణ్యేశ్వరుడు',
      'name_sa': 'श्री सुब्रह्मण्येश्वर स्वामी',
      'icon': '🦚',
      'desc': 'శరవణభవ కార్తికేయ సేనాపతి పూజ',
      'color': const Color(0xFF9D174D),
    },
    {
      'id': 'lakshmi',
      'name_te': 'శ్రీ మహాలక్ష్మీ దేవి',
      'name_sa': 'श्री महालक्ष्मी देवी',
      'icon': '🌸',
      'desc': 'అష్టైశ్వర్య ప్రదాయిని వరలక్ష్మీ పూజ',
      'color': const Color(0xFFB45309),
    },
    {
      'id': 'durga',
      'name_te': 'శ్రీ దుర్గా భవానీ (కనకదుర్గ)',
      'name_sa': 'श्री दुर्गा भवानी',
      'icon': '🌺',
      'desc': 'దుర్గతినాశిని మహిషాసురమర్దిని పూజ',
      'color': const Color(0xFF991B1B),
    },
    {
      'id': 'anjaneya',
      'name_te': 'శ్రీ ఆంజనేయ స్వామి',
      'name_sa': 'श्री आञ्जनेय स्वामी',
      'icon': '🐒',
      'desc': 'వాయుపుత్ర వీర హనుమాన్ సంకటమోచన పూజ',
      'color': const Color(0xFFC2410C),
    },
    {
      'id': 'saraswati',
      'name_te': 'శ్రీ సరస్వతీ దేవి',
      'name_sa': 'श्री सरस्वती देवी',
      'icon': '📖',
      'desc': 'విద్యాబుద్ధి ప్రదాయిని జ్ఞాన సరస్వతి పూజ',
      'color': const Color(0xFF0369A1),
    },
  ];

  void _startPuja(String deityId, String nameTe, String nameSa, bool isFullMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PujaPlayerScreen(
          devoteeProfile: widget.profile,
          deityId: deityId,
          deityNameTe: nameTe,
          deityNameSa: nameSa,
          initialIsFullMode: isFullMode,
          initialPanchang: widget.panchang,
        ),
      ),
    );
  }

  void _openSatyanarayanaVratam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VratamPlayerScreen(vratamId: 'satyanarayana_vratam'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('పూజలు & వ్రతాలు', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('కర్మ యోగం • స్వయం పూజా విధి & వ్రత కల్పం', style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A))),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        children: [
          // 1. Major Vratam Card: Sri Satyanarayana Swamy Vratam
          SacredGlassCard(
            onTap: _openSatyanarayanaVratam,
            borderColor: AppTypography.sacredGold,
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTypography.primaryMaroon.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTypography.sacredGold, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🪔', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'శ్రీ సత్యనారాయణ స్వామి సంపూర్ణ వ్రతం',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTypography.primaryMaroon),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'సామగ్రి చెక్‌లిస్ట్ • 12 పూజా దశలు • సంపూర్ణ 5 కథలు',
                        style: TextStyle(fontSize: 12.5, color: AppTypography.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppTypography.primaryMaroon),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. HERO: Sri Ayyappa Daily Puja Card
          SacredGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildDeityAvatar('ayyappa', '🪔', 52),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'శ్రీ అయ్యప్పస్వామి నిత్య పూజ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTypography.primaryMaroon),
                          ),
                          Text(
                            'హరిహరపుత్ర ధర్మశాస్తా లఘు & షోడశోపచారాలు',
                            style: TextStyle(fontSize: 12, color: AppTypography.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _startPuja('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय्यप्पस्वामी', false),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTypography.primaryMaroon, foregroundColor: Colors.white),
                        icon: const Icon(Icons.flash_on, size: 16),
                        label: const Text('నిత్య లఘు (15 ని)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _startPuja('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय्यप्पस्वामी', true),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFEF3C7), foregroundColor: AppTypography.primaryMaroon),
                        icon: const Icon(Icons.stars, size: 16),
                        label: const Text('షోడశ (45 ని)'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Section Title: All Deities
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Row(
              children: const [
                Text('🌺 ', style: TextStyle(fontSize: 18)),
                Text(
                  'సనాతన ధర్మ దేవతా నిత్య పూజలు',
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon),
                ),
              ],
            ),
          ),

          // 4. Deities List
          ..._deitiesList.where((d) => d['id'] != 'ayyappa').map((deity) {
            final deityId = deity['id'] as String;
            final nameTe = deity['name_te'] as String;
            final nameSa = deity['name_sa'] as String;
            final icon = deity['icon'] as String;
            final desc = deity['desc'] as String;

            return SacredGlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  _buildDeityAvatar(deityId, icon, 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nameTe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                        const SizedBox(height: 2),
                        Text(desc, style: const TextStyle(fontSize: 12, color: AppTypography.textSecondary)),
                      ],
                    ),
                  ),
                  PopupMenuButton<bool>(
                    icon: const Icon(Icons.play_circle_fill, color: AppTypography.primaryMaroon, size: 28),
                    tooltip: 'పూజ ప్రారంభించండి',
                    onSelected: (isFull) => _startPuja(deityId, nameTe, nameSa, isFull),
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: false,
                        child: Text('⚡ నిత్య లఘు పూజ (15 ని)'),
                      ),
                      const PopupMenuItem(
                        value: true,
                        child: Text('🪔 సంపూర్ణ షోడశ పూజ (35 ని)'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
