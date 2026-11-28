import 'package:flutter/material.dart';
import '../data/ayyappa_deeksha_data.dart';
import '../data/ayyappa_bhajana_padi_data.dart';
import '../constants/app_typography.dart';

/// శ్రీ అయ్యప్పస్వామి మండల దీక్షా ప్రత్యేక హబ్ (18 మెట్లు, 108 శరణుఘోష, లోకవీరం, హరివరాసనం, నియామావళి)
class AyyappaDeekshaScreen extends StatefulWidget {
  const AyyappaDeekshaScreen({Key? key}) : super(key: key);

  @override
  _AyyappaDeekshaScreenState createState() => _AyyappaDeekshaScreenState();
}

class _AyyappaDeekshaScreenState extends State<AyyappaDeekshaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _sharanuCounter = 1;
  bool _showPadiPaata = true;
  String _bhajanaSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        backgroundColor: AppTypography.primaryMaroon,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'శ్రీ అయ్యప్ప మండల దీక్షా హబ్',
          style: AppTypography.teluguSloka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTypography.sacredGold,
          indicatorWeight: 3.5,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFFDE68A),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
          tabs: const [
            Tab(text: '📿 18 దివ్య మెట్లు'),
            Tab(text: '🌸 108 శరణు ఘోష'),
            Tab(text: '📜 లోకవీరం స్తోత్రం'),
            Tab(text: '🪔 హరివరాసనం'),
            Tab(text: '🚩 దీక్షా నియామావళి'),
            Tab(text: '🎵 భజన & పడిపాట'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _build18StepsTab(),
          _build108SharanuTab(),
          _buildLokaveeramTab(),
          _buildHarivarasanamTab(),
          _buildNiyamavaliTab(),
          _buildBhajanaPadiTab(),
        ],
      ),
    );
  }

  // TAB 1: 18 Steps
  Widget _build18StepsTab() {
    final steps = AyyappaDeekshaData.holy18Steps;
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final item = steps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1.5,
          color: AppTypography.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.amber.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppTypography.templeDeepOrange,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['step']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTypography.primaryMaroon,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ఆంతర్యం: ${item['tattva']!}',
                        style: const TextStyle(fontSize: 14, color: AppTypography.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTypography.counterBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['mantra']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTypography.textAmber,
                            fontSize: 14,
                          ),
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

  // TAB 2: 108 Sharanu Ghosha
  Widget _build108SharanuTab() {
    final list = AyyappaDeekshaData.sharanu108;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Interactive Counter Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTypography.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTypography.counterBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.shade900.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTypography.primaryMaroon,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'శరణు $_sharanuCounter / ${list.length}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _sharanuCounter = 1),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('మొదటి నుండి'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SelectableText(
                  list[_sharanuCounter - 1],
                  style: AppTypography.teluguSloka(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTypography.primaryMaroon,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_sharanuCounter < list.length) {
                        setState(() => _sharanuCounter++);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTypography.vibrantOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Text('📿', style: TextStyle(fontSize: 20)),
                    label: Text(
                      _sharanuCounter < list.length
                          ? 'స్వామియే శరణమయ్యప్ప! (+1)'
                          : '✓ 108 శరణు ఘోష సంపూర్ణం!',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Full Scrollable List
          Text(
            'శ్రీ అయ్యప్ప 108 శరణు ఘోష సమగ్ర క్రమం',
            style: AppTypography.sacredHeader(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ...list.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final text = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade100),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      '$idx.',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTypography.sacredGoldDark),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.teluguSloka(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        color: AppTypography.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // TAB 3: Lokaveeram
  Widget _buildLokaveeramTab() {
    final verses = AyyappaDeekshaData.lokaveeramVerses;
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final item = verses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.amber.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectableText(
                  item['sloka']!,
                  style: AppTypography.teluguSloka(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: AppTypography.primaryMaroon,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 20),
                Text(
                  'భావం: ${item['meaning']!}',
                  style: AppTypography.meaningText(fontSize: 15.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TAB 4: Harivarasanam
  Widget _buildHarivarasanamTab() {
    final verses = AyyappaDeekshaData.harivarasanamVerses;
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final item = verses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.amber.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectableText(
                  item['sloka']!,
                  style: AppTypography.teluguSloka(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: AppTypography.primaryMaroon,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 20),
                Text(
                  'భావం: ${item['meaning']!}',
                  style: AppTypography.meaningText(fontSize: 15.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TAB 5: Niyamavali
  Widget _buildNiyamavaliTab() {
    final rules = AyyappaDeekshaData.deekshaRules;
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final item = rules[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.amber.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTypography.primaryMaroon,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['desc']!,
                  style: AppTypography.meaningText(fontSize: 15.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TAB 6: Bhajana Songs & Padi Paata (అధ్యాయాలు 26 & 27)
  Widget _buildBhajanaPadiTab() {
    final allSongs = AyyappaBhajanaPadiData.bhajanaSongs;
    final filteredSongs = _bhajanaSearchQuery.trim().isEmpty
        ? allSongs
        : allSongs.where((s) {
            final t = s['title']!.toLowerCase();
            final l = s['lyrics']!.toLowerCase();
            final q = _bhajanaSearchQuery.toLowerCase();
            return t.contains(q) || l.contains(q);
          }).toList();

    return Column(
      children: [
        // Sub-Mode Switcher: Padi Paata vs Bhajana Songs
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _showPadiPaata = true),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _showPadiPaata ? AppTypography.primaryMaroon : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _showPadiPaata ? AppTypography.primaryMaroon : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '🪔 18 మెట్ల పడిపాట',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: _showPadiPaata ? Colors.white : AppTypography.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _showPadiPaata = false),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: !_showPadiPaata ? AppTypography.sacredGoldDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !_showPadiPaata ? AppTypography.sacredGoldDark : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '🎵 22 భజన పాటలు',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: !_showPadiPaata ? Colors.white : AppTypography.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content Area
        Expanded(
          child: _showPadiPaata
              ? _buildPadiPaataView()
              : _buildBhajanaSongsList(filteredSongs),
        ),
      ],
    );
  }

  Widget _buildPadiPaataView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFFDE68A), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: const [
                    Text('🚩 ', style: TextStyle(fontSize: 20)),
                    Expanded(
                      child: Text(
                        'అయ్యప్ప స్వామి 18 మెట్ల పడిపాట (గురుస్వామి & స్వాముల ప్రతిస్పందన)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppTypography.primaryMaroon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SelectableText(
                AyyappaBhajanaPadiData.padiPaataLyrics,
                style: AppTypography.teluguSloka(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                  height: 1.8,
                  color: AppTypography.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBhajanaSongsList(List<Map<String, String>> songs) {
    return Column(
      children: [
        // Song Search Input
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: TextField(
            onChanged: (val) => setState(() => _bhajanaSearchQuery = val),
            decoration: InputDecoration(
              hintText: 'భజన పాటను వెతకండి (Search Song)...',
              prefixIcon: const Icon(Icons.search, color: AppTypography.primaryMaroon),
              suffixIcon: _bhajanaSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _bhajanaSearchQuery = ''),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.amber.shade300),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber.shade200),
                ),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🎵', style: TextStyle(fontSize: 18)),
                  ),
                  title: Text(
                    song['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTypography.primaryMaroon,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SelectableText(
                        song['lyrics']!,
                        style: AppTypography.teluguSloka(
                          fontSize: 15.5,
                          height: 1.7,
                          color: AppTypography.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
