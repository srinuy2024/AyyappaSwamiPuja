// lib/screens/vratam_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_typography.dart';
import '../data/satyanarayana_vratam_data.dart';
import '../data/varalakshmi_vratam_data.dart';
import '../data/vinayaka_chavithi_vratam_data.dart';
import '../models/library_model.dart';
import '../services/vedic_voice_service.dart';

class VratamPlayerScreen extends StatefulWidget {
  final String vratamId;
  const VratamPlayerScreen({super.key, this.vratamId = 'satyanarayana_vratam'});

  @override
  State<VratamPlayerScreen> createState() => _VratamPlayerScreenState();
}

class _VratamPlayerScreenState extends State<VratamPlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<VratamSamagriItem> _samagriList;
  late List<VratamKathaChapter> _chapters;
  late List<String> _pujaSteps;
  late String _vratamTitleTe;
  late String _subtitleTe;

  int _selectedChapterIndex = 0;
  final VedicVoiceService _voiceService = VedicVoiceService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadVratamData();
  }

  void _loadVratamData() {
    if (widget.vratamId == 'varalakshmi_vratam') {
      _vratamTitleTe = VaralakshmiVratamData.vratamTitleTe;
      _subtitleTe = VaralakshmiVratamData.subtitleTe;
      _samagriList = VaralakshmiVratamData.getSamagriList();
      _chapters = VaralakshmiVratamData.getKathaChapters();
      _pujaSteps = VaralakshmiVratamData.getPujaStepsSummary();
    } else if (widget.vratamId == 'vinayaka_vratam') {
      _vratamTitleTe = VinayakaChavithiVratamData.vratamTitleTe;
      _subtitleTe = VinayakaChavithiVratamData.subtitleTe;
      _samagriList = VinayakaChavithiVratamData.getSamagriList();
      _chapters = VinayakaChavithiVratamData.getKathaChapters();
      _pujaSteps = VinayakaChavithiVratamData.getPujaStepsSummary();
    } else {
      _vratamTitleTe = SatyanarayanaVratamData.vratamTitleTe;
      _subtitleTe = 'స్వయం వ్రత కల్పం • స్కాంద పురాణోక్తం';
      _samagriList = SatyanarayanaVratamData.getSamagriList();
      _chapters = SatyanarayanaVratamData.getKathaChapters();
      _pujaSteps = SatyanarayanaVratamData.getPujaStepsSummary();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _voiceService.stop();
    super.dispose();
  }

  int get _checkedCount => _samagriList.where((i) => i.isChecked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _vratamTitleTe,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _subtitleTe,
              style: const TextStyle(fontSize: 11, color: Color(0xFFFDE68A)),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTypography.sacredGold,
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(
              icon: const Icon(Icons.checklist_rounded, size: 20),
              text: '1. సామగ్రి (${_checkedCount}/${_samagriList.length})',
            ),
            const Tab(
              icon: Icon(Icons.temple_hindu_rounded, size: 20),
              text: '2. పూజా విధి',
            ),
            Tab(
              icon: const Icon(Icons.menu_book_rounded, size: 20),
              text: '3. వ్రత కథ (${_chapters.length})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSamagriTab(),
          _buildPujaVidhiTab(),
          _buildKathaTab(),
        ],
      ),
    );
  }

  // 1. సామగ్రి చెక్‌లిస్ట్ ట్యాబ్
  Widget _buildSamagriTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      children: [
        Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF59E0B)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'వ్రతం ప్రారంభించే ముందు కావలసిన సామగ్రిని సిద్ధం చేసుకొని టిక్ చేయండి. మొత్తం ${_samagriList.length} వస్తువులలో ${_checkedCount} సిద్ధమయ్యాయి.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.3),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._samagriList.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: item.isChecked ? AppTypography.successGreen.withValues(alpha: 0.5) : Colors.grey.shade300,
              ),
            ),
            color: item.isChecked ? const Color(0xFFF0FDF4) : Colors.white,
            elevation: 1.0,
            child: CheckboxListTile(
              value: item.isChecked,
              activeColor: AppTypography.successGreen,
              title: Text(
                item.nameTe,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                  color: item.isChecked ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
              subtitle: Text(
                'పరిమాణం: ${item.quantity} • ${item.significance}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              onChanged: (val) {
                HapticFeedback.selectionClick();
                setState(() {
                  item.isChecked = val ?? false;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  // 2. వ్రత పూజా విధి ట్యాబ్
  Widget _buildPujaVidhiTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      children: [
        Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: AppTypography.primaryMaroon.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTypography.primaryMaroon.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '🪔 మండప స్థాపన & పూజా సంకల్పం',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon),
              ),
              SizedBox(height: 6),
              Text(
                'తూర్పు లేదా ఉత్తర దిశగా పీటను వేసి, దానిపై బియ్యం పరిచి, మధ్యలో కలశాన్ని ఉంచండి. కలశంపై కొబ్బరికాయ, పసుపు గణపతిని ప్రతిష్టించి పూజను ప్రారంభించండి.',
                style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ..._pujaSteps.asMap().entries.map((entry) {
          final idx = entry.key;
          final stepText = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: AppTypography.primaryMaroon,
                  child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    stepText,
                    style: const TextStyle(fontSize: 14, height: 1.35, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 3. సంపూర్ణ వ్రత కథ ట్యాబ్
  Widget _buildKathaTab() {
    final chapter = _chapters[_selectedChapterIndex];

    return Column(
      children: [
        // Chapter selector pills
        Container(
          height: 48,
          color: Colors.amber.shade50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            itemCount: _chapters.length,
            itemBuilder: (ctx, i) {
              final isSel = i == _selectedChapterIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text('అధ్యాయం ${i + 1}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSel ? Colors.white : AppTypography.primaryMaroon)),
                  selected: isSel,
                  selectedColor: AppTypography.primaryMaroon,
                  backgroundColor: Colors.white,
                  onSelected: (val) {
                    if (val) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedChapterIndex = i;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),

        // Katha Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTypography.cardBorder),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    chapter.titleTe,
                    style: AppTypography.sacredHeader(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chapter.titleSa,
                    style: const TextStyle(fontSize: 13, color: AppTypography.sacredGold, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 24, thickness: 1.2),

                  // Full Story Prose
                  SelectableText(
                    chapter.fullKathaTe,
                    style: const TextStyle(fontSize: 15.5, height: 1.7, color: Color(0xFF1F2937), letterSpacing: 0.2),
                  ),

                  const SizedBox(height: 20),
                  // Spiritual Moral Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('💡 ', style: TextStyle(fontSize: 16)),
                            Text('ఆధ్యాత్మిక అంతరార్థం:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF92400E))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter.spiritualMessage,
                          style: const TextStyle(fontSize: 13.5, color: Color(0xFF78350F), height: 1.35),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Navigation between chapters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_selectedChapterIndex > 0)
                        OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedChapterIndex--);
                          },
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('మునుపటి కథ'),
                        )
                      else
                        const SizedBox.shrink(),
                      if (_selectedChapterIndex < _chapters.length - 1)
                        ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedChapterIndex++);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppTypography.primaryMaroon, foregroundColor: Colors.white),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('తదుపరి అధ్యాయం'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✓ $_vratamTitleTe కథ సంపూర్ణమాయెను! మంగళం మహత్!'),
                                backgroundColor: AppTypography.successGreen,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppTypography.successGreen, foregroundColor: Colors.white),
                          icon: const Icon(Icons.check_circle, size: 16),
                          label: const Text('మహామంగళ హారతి'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
