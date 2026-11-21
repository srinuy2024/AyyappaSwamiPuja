// lib/screens/suprabhatam_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/suprabhatam_data.dart';
import '../constants/app_typography.dart';

/// సర్వ దేవతా సుప్రభాత నిధి స్క్రీన్ (Morning Awakening Hymns Suite)
class SuprabhatamScreen extends StatefulWidget {
  const SuprabhatamScreen({Key? key}) : super(key: key);

  @override
  _SuprabhatamScreenState createState() => _SuprabhatamScreenState();
}

class _SuprabhatamScreenState extends State<SuprabhatamScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _activeScript = 'telugu'; // 'telugu' or 'sanskrit'
  bool _showMeaning = true;
  bool _isAutoScrolling = false;
  Timer? _scrollTimer;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'శ్రీ వేంకటేశ్వర',
      'icon': '👑',
      'deity': 'venkateswara',
      'list': SuprabhatamData.venkateswaraSuprabhatam,
    },
    {
      'title': 'శ్రీ అయ్యప్ప',
      'icon': '🪔',
      'deity': 'ayyappa',
      'list': SuprabhatamData.ayyappaSuprabhatam,
    },
    {
      'title': 'పరమశివుడు',
      'icon': '🔱',
      'deity': 'shiva',
      'list': SuprabhatamData.shivaSuprabhatam,
    },
    {
      'title': 'శ్రీ మహాగణపతి',
      'icon': '🐘',
      'deity': 'ganapathi',
      'list': SuprabhatamData.ganeshaSuprabhatam,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleAutoScroll() {
    setState(() {
      _isAutoScrolling = !_isAutoScrolling;
    });

    if (_isAutoScrolling) {
      _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          final current = _scrollController.offset;
          if (current >= max) {
            _toggleAutoScroll();
          } else {
            _scrollController.animateTo(
              current + 2.0,
              duration: const Duration(milliseconds: 50),
              curve: Curves.linear,
            );
          }
        }
      });
    } else {
      _scrollTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        backgroundColor: AppTypography.primaryMaroon,
        foregroundColor: Colors.white,
        elevation: 3,
        title: const Text(
          '🌅 సర్వ దేవతా సుప్రభాత నిధి',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          // Script toggle
          TextButton.icon(
            onPressed: () {
              setState(() {
                _activeScript = _activeScript == 'telugu' ? 'sanskrit' : 'telugu';
              });
            },
            icon: const Icon(Icons.translate, color: Colors.white, size: 16),
            label: Text(
              _activeScript == 'telugu' ? 'తెలుగు' : 'देवनागरी',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          // Meaning toggle
          IconButton(
            icon: Icon(
              _showMeaning ? Icons.menu_book : Icons.menu_book_outlined,
              color: Colors.white,
            ),
            tooltip: 'తాత్పర్యం చూడండి/దాచండి',
            onPressed: () {
              setState(() {
                _showMeaning = !_showMeaning;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTypography.sacredGold,
          indicatorWeight: 3.5,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFFDE68A),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: _tabs.map((t) => Tab(text: '${t['icon']} ${t['title']}')).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAutoScroll,
        backgroundColor: _isAutoScrolling ? Colors.red.shade700 : AppTypography.primaryMaroon,
        foregroundColor: Colors.white,
        icon: Icon(_isAutoScrolling ? Icons.pause : Icons.play_arrow),
        label: Text(_isAutoScrolling ? 'ఆపు' : 'ఆటో-స్క్రోల్ పారాయణ'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => _buildSuprabhatamTab(tab)).toList(),
      ),
    );
  }

  Widget _buildSuprabhatamTab(Map<String, dynamic> tab) {
    final list = tab['list'] as List<Map<String, dynamic>>;
    final invocation = SuprabhatamData.morningInvocation;

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
      children: [
        // 1. Morning Awakening Banner
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFFDE68A), width: 1.2),
          ),
          color: const Color(0xFFFFFBEB),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('☀️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      _activeScript == 'telugu' ? invocation['title_te'] : invocation['title_sa'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                        color: AppTypography.primaryMaroon,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _activeScript == 'telugu' ? invocation['sloka_te'] : invocation['sloka_sa'],
                  style: _activeScript == 'telugu'
                      ? AppTypography.teluguSloka(fontSize: 16.5)
                      : AppTypography.sanskritSloka(fontSize: 16.5),
                ),
                if (_showMeaning) ...[
                  const Divider(color: Color(0xFFFDE68A), height: 16),
                  Text(
                    invocation['meaning_te'],
                    style: AppTypography.meaningText(fontSize: 13.5),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Text(tab['icon'], style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '${tab['title']} సుప్రభాత శ్లోకాలు (${list.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTypography.primaryMaroon,
                ),
              ),
            ],
          ),
        ),

        // 2. Suprabhatam Slokas
        ...list.map((item) {
          final isTelugu = _activeScript == 'telugu';
          final sloka = isTelugu ? item['sloka_te'] : item['sloka_sa'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.amber.shade200, width: 1),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTypography.templeDeepOrange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'శ్లోకం #${item['num']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTypography.templeDeepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sloka,
                    style: isTelugu
                        ? AppTypography.teluguSloka(fontSize: 17.5)
                        : AppTypography.sanskritSloka(fontSize: 17.5),
                  ),
                  if (_showMeaning && item['meaning_te'] != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade100),
                      ),
                      child: Text(
                        item['meaning_te'],
                        style: AppTypography.meaningText(fontSize: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
