// lib/screens/pujas_hub_screen.dart
import 'package:flutter/material.dart';
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
  final List<Map<String, dynamic>> _vratamsList = [
    {
      'id': 'satyanarayana_vratam',
      'title': 'శ్రీ సత్యనారాయణ స్వామి సంపూర్ణ వ్రతం',
      'subtitle': 'సామగ్రి చెక్‌లిస్ట్ • 12 పూజా దశలు • సంపూర్ణ 5 కథలు',
      'badge': 'స్కాంద పురాణోక్తం',
      'icon': '🪔',
      'color': const Color(0xFFF59E0B),
    },
    {
      'id': 'varalakshmi_vratam',
      'title': 'శ్రీ వరలక్ష్మీ దేవి సంపూర్ణ వ్రత కల్పం',
      'subtitle': 'నవగ్రంథి తోర పూజ • చారుమతీ కథ • వాయన దానం',
      'badge': 'భవిష్యోత్తర పురాణోక్తం',
      'icon': '🌸',
      'color': const Color(0xFFF472B6),
    },
    {
      'id': 'vinayaka_vratam',
      'title': 'శ్రీ సిద్ధివినాయక వ్రతం (వినాయక చవితి)',
      'subtitle': '21 పత్ర పూజ • శమంతకోపాఖ్యానం • చంద్ర శాప నివారణ',
      'badge': 'గణేశ ఖండోక్తం',
      'icon': '🐘',
      'color': const Color(0xFFFB923C),
    },
  ];

  final List<Map<String, dynamic>> _deitiesList = [
    {
      'id': 'ayyappa',
      'name_te': 'శ్రీ అయ్యప్పస్వామి',
      'name_sa': 'श्री अय్యప్పస్వామి',
      'icon': '🪔',
      'desc': 'హరిహరపుత్ర మండల దీక్ష నిత్య పూజ & పడిపూజ',
      'color': const Color(0xFFF59E0B),
    },
    {
      'id': 'ganapathi',
      'name_te': 'శ్రీ మహాగణపతి',
      'name_sa': 'श्री महागणाधिपतये नमः',
      'icon': '🐘',
      'desc': 'విఘ్న నివారణ సంకష్టహర చతుర్థి & నిత్య పూజ',
      'color': const Color(0xFFFB923C),
    },
    {
      'id': 'shiva',
      'name_te': 'శ్రీ పరమశివుడు (మహాదేవుడు)',
      'name_sa': 'श्री साम्बसदाशिवाय नमः',
      'icon': '🔱',
      'desc': 'బిల్వార్చన, రుద్రాభిషేకం & ప్రదోష పూజ',
      'color': const Color(0xFF38BDF8),
    },
    {
      'id': 'durga',
      'name_te': 'శ్రీ కనకదుర్గా దేవి',
      'name_sa': 'श्री दुर्गार्पणमस्तु',
      'icon': '🦁',
      'desc': 'సర్వబాధా నివారణ నవరాత్రి & నిత్య పూజ',
      'color': const Color(0xFFF87171),
    },
    {
      'id': 'lakshmi',
      'name_te': 'శ్రీ మహాలక్ష్మీ దేవి',
      'name_sa': 'श्री महालक्ष्म्यै नमः',
      'icon': '🪷',
      'desc': 'అష్టైశ్వర్య ప్రాప్తి కనకధారా & శుక్రవార పూజ',
      'color': const Color(0xFFFBBF24),
    },
    {
      'id': 'venkateswara',
      'name_te': 'శ్రీ వేంకటేశ్వర స్వామి',
      'name_sa': 'श्री श्रीనివాసాయ నమః',
      'icon': '🛕',
      'desc': 'కలియుగ ప్రత్యక్ష దైవ శ్రీవారి నిత్య తోమాల పూజ',
      'color': const Color(0xFFF59E0B),
    },
    {
      'id': 'subramanya',
      'name_te': 'శ్రీ సుబ్రహ్మణ్య స్వామి',
      'name_sa': 'श्री స్కంద షణ్ముఖాయ నమః',
      'icon': '🦚',
      'desc': 'సర్పదోష నివారణ షష్ఠి & నిత్య పూజ',
      'color': const Color(0xFFEA580C),
    },
    {
      'id': 'anjaneya',
      'name_te': 'శ్రీ ఆంజనేయ స్వామి',
      'name_sa': 'श्री ఆఞ్జనేయ స్వామి',
      'icon': '🐒',
      'desc': 'వాయుపుత్ర వీర హనుమాన్ సంకటమోచన పూజ',
      'color': const Color(0xFFFB923C),
    },
    {
      'id': 'saraswati',
      'name_te': 'శ్రీ సరస్వతీ దేవి',
      'name_sa': 'श्री సరస్వతీ దేవి',
      'icon': '📖',
      'desc': 'విద్యాబుద్ధి ప్రదాయిని జ్ఞాన సరస్వతి పూజ',
      'color': const Color(0xFF2DD4BF),
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

  void _openVratam(String vratamId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VratamPlayerScreen(vratamId: vratamId),
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
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(icon, style: TextStyle(fontSize: size * 0.52)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0A0718),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'పూజలు & వ్రతాలు',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              'కర్మ యోగం • స్వయం పూజా విధి & వ్రత కల్పం',
              style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A)),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Ambient Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A0718),
                    Color(0xFF180D2C),
                    Color(0xFF281039),
                    Color(0xFF12071F),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEA580C).withValues(alpha: 0.18),
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 90),
              children: [
                // Section 1: Major Self-Guided Vratams (ప్రముఖ స్వయం వ్రతాలు)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Row(
                    children: const [
                      Text('🌟 ', style: TextStyle(fontSize: 18)),
                      Text(
                        'స్వయం వ్రత కల్పాలు (Self-Guided Vratams)',
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                ..._vratamsList.map((vratam) {
                  final color = vratam['color'] as Color;
                  return SacredGlassCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    onTap: () => _openVratam(vratam['id'] as String),
                    borderColor: color.withValues(alpha: 0.45),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: color.withValues(alpha: 0.45), width: 1.2),
                          ),
                          alignment: Alignment.center,
                          child: Text(vratam['icon'] as String, style: const TextStyle(fontSize: 26)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      vratam['title'] as String,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: color.withValues(alpha: 0.3)),
                                    ),
                                    child: Text(
                                      vratam['badge'] as String,
                                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                vratam['subtitle'] as String,
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, size: 14, color: color),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Section 2: HERO: Sri Ayyappa Daily Puja Card
                SacredGlassCard(
                  borderColor: const Color(0xFFF59E0B).withValues(alpha: 0.5),
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
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFFFDE68A)),
                                ),
                                Text(
                                  'హరిహరపుత్ర ధర్మశాస్తా లఘు & షోడశోపచారాలు',
                                  style: TextStyle(fontSize: 12, color: Colors.white70),
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
                              onPressed: () => _startPuja('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय్యప్పస్వామి', false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD97706),
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.flash_on, size: 16),
                              label: const Text('నిత్య లఘు (15 ని)'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _startPuja('ayyappa', 'శ్రీ అయ్యప్పస్వామి', 'श्री अय్యప్పస్వామి', true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                foregroundColor: const Color(0xFFFDE68A),
                                side: BorderSide(color: const Color(0xFFF59E0B).withValues(alpha: 0.5)),
                              ),
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

                // Section 3: Section Title: All Deities
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Row(
                    children: const [
                      Text('🌺 ', style: TextStyle(fontSize: 18)),
                      Text(
                        'సనాతన ధర్మ దేవతా నిత్య పూజలు',
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Deities List
                ..._deitiesList.where((d) => d['id'] != 'ayyappa').map((deity) {
                  final deityId = deity['id'] as String;
                  final nameTe = deity['name_te'] as String;
                  final nameSa = deity['name_sa'] as String;
                  final icon = deity['icon'] as String;
                  final desc = deity['desc'] as String;
                  final color = deity['color'] as Color;

                  return SacredGlassCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    borderColor: Colors.white.withValues(alpha: 0.16),
                    child: Row(
                      children: [
                        _buildDeityAvatar(deityId, icon, 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nameTe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(desc, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                        PopupMenuButton<bool>(
                          icon: Icon(Icons.play_circle_fill, color: color, size: 30),
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
          ),
        ],
      ),
    );
  }
}
