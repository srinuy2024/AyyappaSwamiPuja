// lib/screens/jnana_library_screen.dart
import 'package:flutter/material.dart';
import '../constants/app_typography.dart';
import '../data/bhagavad_gita_data.dart';
import '../data/vedic_suktas_data.dart';
import '../widgets/sacred_glass_card.dart';

class JnanaLibraryScreen extends StatefulWidget {
  const JnanaLibraryScreen({super.key});

  @override
  State<JnanaLibraryScreen> createState() => _JnanaLibraryScreenState();
}

class _JnanaLibraryScreenState extends State<JnanaLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('సనాతన జ్ఞాన నిధి', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('భగవద్గీత • వేద సూక్తాలు • శాంతి మంత్రాలు', style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A))),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTypography.sacredGold,
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded, size: 18), text: '1. భగవద్గీత'),
            Tab(icon: Icon(Icons.auto_stories_rounded, size: 18), text: '2. వేద సూక్తములు'),
            Tab(icon: Icon(Icons.wb_sunny_rounded, size: 18), text: '3. శాంతి పాఠాలు'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGitaTab(),
          _buildVedicSuktasTab(),
          _buildShantiMantrasTab(),
        ],
      ),
    );
  }

  // 1. భగవద్గీత ట్యాబ్ (18 అధ్యాయాలు & దిన శ్లోకాలు)
  Widget _buildGitaTab() {
    final slokas = BhagavadGitaData.dailyLifeSlokas;
    final chapters = BhagavadGitaData.chaptersOverview;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // Daily Life Slokas Banner
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: const [
              Text('✨ ', style: TextStyle(fontSize: 16)),
              Text('నిత్య జీవన మార్గదర్శక శ్లోకాలు', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTypography.primaryMaroon)),
            ],
          ),
        ),
        ...slokas.map((item) {
          return SacredGlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTypography.primaryMaroon.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'అధ్యాయం ${item.chapter} • శ్లోకం ${item.verse}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: AppTypography.primaryMaroon),
                      ),
                    ),
                    const Icon(Icons.bookmark_outline, color: AppTypography.sacredGold, size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  item.slokaSa,
                  style: const TextStyle(fontSize: 14, color: AppTypography.primaryMaroon, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  item.slokaTe,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 16),
                Text(
                  'తాత్పర్యం: ${item.tatparyam}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '💡 ఆచరణ: ${item.practicalLesson}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 10),

        // 18 Chapters Overview
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: const [
              Text('📜 ', style: TextStyle(fontSize: 16)),
              Text('శ్రీమద్ భగవద్గీత 18 అధ్యాయాల అవలోకనం', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTypography.primaryMaroon)),
            ],
          ),
        ),
        ...chapters.map((ch) {
          final num = ch['num'] as int;
          final nameTe = ch['nameTe'] as String;
          final verses = ch['verses'] as int;
          final summary = ch['summary'] as String;

          return SacredGlassCard(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: AppTypography.primaryMaroon,
                child: Text('$num', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              title: Text(nameTe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Colors.black87)),
              subtitle: Text('$verses శ్లోకాలు', style: const TextStyle(fontSize: 11.5, color: AppTypography.textSecondary)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(summary, style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF1F2937))),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 2. వేద సూక్తములు ట్యాబ్ (శ్రీ సూక్తం & పురుష సూక్తం)
  Widget _buildVedicSuktasTab() {
    final suktas = [VedicSuktasData.sriSuktam, VedicSuktasData.purushaSuktam];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: suktas.length,
      itemBuilder: (ctx, i) {
        final sukta = suktas[i];
        return SacredGlassCard(
          margin: const EdgeInsets.only(bottom: 14),
          borderColor: AppTypography.sacredGold,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTypography.sacredGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTypography.sacredGold, width: 1.2),
                    ),
                    alignment: Alignment.center,
                    child: Text(i == 0 ? '🌸' : '🕉️', style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sukta.titleTe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTypography.primaryMaroon)),
                        Text(sukta.vedaSource, style: const TextStyle(fontSize: 11.5, color: AppTypography.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(sukta.descriptionTe, style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.35)),
              const Divider(height: 18),

              // Verses List
              ...sukta.verses.map((v) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: AppTypography.sacredGold,
                            child: Text('${v.number}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          const Text('వైదిక ఋక్కు', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTypography.sacredGold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        v.mantraSa,
                        style: const TextStyle(fontSize: 14.5, color: AppTypography.primaryMaroon, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        v.mantraTe,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ప్రతిపదార్థం & భావం: ${v.meaningTe}',
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.35),
                      ),
                    ],
                  ),
                );
              }),

              // Phalasruti
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🌟 ఫలశ్రుతి:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF15803D))),
                    const SizedBox(height: 2),
                    Text(sukta.phalasruti, style: const TextStyle(fontSize: 11.5, color: Color(0xFF166534), height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. శాంతి పాఠాలు ట్యాబ్ (సార్వత్రిక ప్రార్థనలు)
  Widget _buildShantiMantrasTab() {
    final mantras = VedicSuktasData.shantiMantras;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: mantras.length,
      itemBuilder: (ctx, i) {
        final m = mantras[i];
        return SacredGlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    m['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTypography.primaryMaroon),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      m['source'] ?? '',
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SelectableText(
                m['mantra'] ?? '',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.45),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 16),
              Text(
                'తాత్పర్యం: ${m['meaning']}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }
}
