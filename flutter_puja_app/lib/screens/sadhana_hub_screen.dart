// lib/screens/sadhana_hub_screen.dart
import 'package:flutter/material.dart';
import '../constants/app_typography.dart';
import '../models/devotee_profile.dart';
import '../widgets/sacred_glass_card.dart';
import 'japa_mala_screen.dart';
import 'ayyappa_deeksha_screen.dart';

class SadhanaHubScreen extends StatefulWidget {
  final DevoteeProfile profile;

  const SadhanaHubScreen({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<SadhanaHubScreen> createState() => _SadhanaHubScreenState();
}

class _SadhanaHubScreenState extends State<SadhanaHubScreen> {
  void _openJapaMala() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JapaMalaScreen()),
    );
  }

  void _openAyyappaDeeksha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AyyappaDeekshaScreen()),
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
            Text('నిత్య సాధనా నిధి', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('ధ్యాన యోగం • 108 జపమాల & మండల దీక్షా సాధన', style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A))),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        children: [
          // 1. Digital 108 Japa Mala Hero Card
          SacredGlassCard(
            onTap: _openJapaMala,
            borderColor: const Color(0xFF7C3AED),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7C3AED), width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: const Text('📿', style: TextStyle(fontSize: 30)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'డిజిటల్ 108 జపమాల కౌంటర్',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7C3AED)),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'హ్యాప్టిక్ వైబ్రేషన్‌తో మంత్ర జపం • అయ్యప్ప, శివ, గాయత్రీ మంత్రాలు',
                        style: TextStyle(fontSize: 12.5, color: AppTypography.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7C3AED)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Ayyappa 41-Day Mandala Deeksha Hub Card
          SacredGlassCard(
            onTap: _openAyyappaDeeksha,
            borderColor: AppTypography.templeDeepOrange,
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTypography.templeDeepOrange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTypography.templeDeepOrange, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🚩', style: TextStyle(fontSize: 30)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'అయ్యప్ప మండల దీక్షా హబ్',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTypography.templeDeepOrange),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '18 పడి పాటలు • 108 శరణు ఘోష • ఇరుముడి సామాగ్రి చెక్‌లిస్ట్',
                        style: TextStyle(fontSize: 12.5, color: AppTypography.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppTypography.templeDeepOrange),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Devotee Sankalpa Profile Info Card
          SacredGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('👤 ', style: TextStyle(fontSize: 18)),
                    Text(
                      'భక్తుని నిత్య సంకల్ప వివరాలు',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTypography.primaryMaroon),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('గోత్రం: ${widget.profile.gotram}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                Text('కర్త: ${widget.profile.kartaName} • ధర్మపత్ని: ${widget.profile.spouseName}', style: const TextStyle(fontSize: 13, color: AppTypography.textSecondary)),
                if (widget.profile.childrenNames.isNotEmpty)
                  Text('సంతానం: ${widget.profile.childrenNames}', style: const TextStyle(fontSize: 13, color: AppTypography.textSecondary)),
                const SizedBox(height: 6),
                const Text('పూజలో సంకల్పం చెప్పుకునేటప్పుడు ఈ వివరాలు మంత్రంలో స్వయంచాలకంగా అనుసంధానించబడతాయి.', style: TextStyle(fontSize: 11.5, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
