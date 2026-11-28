// lib/screens/jnana_library_screen.dart
import 'package:flutter/material.dart';
import '../constants/app_typography.dart';
import '../data/bhagavad_gita_data.dart';


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
    _tabController = TabController(length: 2, vsync: this);
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
            Text('జ్ఞాన నిధి • శ్రీమద్ భగవద్గీత', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('18 అధ్యాయాలు & నిత్య జీవిత శ్లోకాలు', style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A))),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTypography.sacredGold,
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.star_rounded, size: 20), text: 'నిత్య జీవన శ్లోకాలు'),
            Tab(icon: Icon(Icons.menu_book_rounded, size: 20), text: '18 అధ్యాయాల పరిచయం'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyLifeSlokasTab(),
          _buildChaptersOverviewTab(),
        ],
      ),
    );
  }

  Widget _buildDailyLifeSlokasTab() {
    final slokas = BhagavadGitaData.dailyLifeSlokas;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: slokas.length,
      itemBuilder: (ctx, i) {
        final item = slokas[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppTypography.cardBorder, width: 1.2),
          ),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTypography.primaryMaroon.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'అధ్యాయం ${item.chapter} • శ్లోకం ${item.verse}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTypography.primaryMaroon),
                      ),
                    ),
                    const Icon(Icons.bookmark_border, color: AppTypography.sacredGold, size: 20),
                  ],
                ),
                const SizedBox(height: 12),

                // Sanskrit / Telugu Sloka
                SelectableText(
                  item.slokaTe,
                  style: AppTypography.teluguSloka(fontSize: 16.5),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 20, thickness: 1.0),

                // Word-by-word meaning
                const Text('పద విభాగం & ప్రతిపదార్థం:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTypography.primaryMaroon)),
                const SizedBox(height: 4),
                Text(item.wordByWord, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),

                const SizedBox(height: 10),
                // Simple meaning
                const Text('సరళ తాత్పర్యం:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTypography.primaryMaroon)),
                const SizedBox(height: 4),
                Text(item.tatparyam, style: AppTypography.meaningText(fontSize: 13.5)),

                const SizedBox(height: 12),
                // Life lesson
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌱 ', style: TextStyle(fontSize: 15)),
                      Expanded(
                        child: Text(
                          'ఆచరణాత్మక జీవిత సూత్రం: ${item.practicalLesson}',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF78350F)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChaptersOverviewTab() {
    final chapters = BhagavadGitaData.chaptersOverview;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: chapters.length,
      itemBuilder: (ctx, i) {
        final ch = chapters[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTypography.primaryMaroon,
              child: Text('${ch['num']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            title: Text(
              'అధ్యాయం ${ch['num']}: ${ch['nameTe']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Colors.black87),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text('${ch['summary']}', style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.3)),
                const SizedBox(height: 3),
                Text('మొత్తం శ్లోకాలు: ${ch['verses']}', style: const TextStyle(fontSize: 11, color: AppTypography.templeDeepOrange, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
