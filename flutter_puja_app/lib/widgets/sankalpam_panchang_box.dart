import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/panchangam_data.dart';
import '../models/devotee_profile.dart';
import '../services/panchangam_service.dart';
import '../services/dynamic_sankalpam_service.dart';
import '../constants/app_typography.dart';
import 'sacred_glass_card.dart';

/// శాస్త్రోక్త ద్రిక-పంచాంగం & లైవ్ పూజా సంకల్ప దర్శిని బాక్స్ (Dedicated Sankalpam & Panchangam Box)
class SankalpamPanchangBox extends StatelessWidget {
  final PanchangamData panchang;
  final DevoteeProfile profile;
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final VoidCallback onResetDate;
  final VoidCallback onEditProfile;
  final bool isGlassmorphic;

  const SankalpamPanchangBox({
    Key? key,
    required this.panchang,
    required this.profile,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onResetDate,
    required this.onEditProfile,
    this.isGlassmorphic = false,
  }) : super(key: key);

  bool get _isToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  void _showFullSankalpamModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FullSankalpamSheet(
        profile: profile,
        panchang: panchang,
        selectedDate: selectedDate,
        onEditProfile: onEditProfile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Box Header: Title, Telugu Date, & Date Picker Actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isGlassmorphic ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isGlassmorphic ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFFDE68A)),
              ),
              child: const Text('🪔', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'నేటి పంచాంగం • సంకల్ప దర్శిని',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isGlassmorphic ? Colors.white : AppTypography.primaryMaroon,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '📅 ${PanchangamService.formatTeluguDate(selectedDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isGlassmorphic ? const Color(0xFFFDE68A) : AppTypography.sacredGoldDark,
                    ),
                  ),
                ],
              ),
            ),
            // Date Picker & Today Reset Action Chips
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isToday)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: InkWell(
                      onTap: onResetDate,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: isGlassmorphic ? const Color(0xFF059669) : const Color(0xFF047857),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'నేడు',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  onTap: onSelectDate,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isGlassmorphic ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isGlassmorphic ? Colors.white.withValues(alpha: 0.3) : AppTypography.sacredGold,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 13,
                          color: isGlassmorphic ? const Color(0xFFFDE68A) : AppTypography.primaryMaroon,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'తేదీ మార్చు',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isGlassmorphic ? Colors.white : AppTypography.primaryMaroon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 1,
          color: isGlassmorphic ? Colors.white.withValues(alpha: 0.18) : const Color(0xFFFDE68A),
        ),
        const SizedBox(height: 12),

            // 2. Structured Grid of Sankalpam Parameters
            // Row 1: Samvatsaram & Ayanam/Rithu
            Row(
              children: [
                Expanded(
                  child: _buildParamTile(
                    icon: '🕉️',
                    labelTe: 'సంవత్సరం (Year)',
                    valTe: 'శ్రీ ${panchang.samvatsaraTe} నామ',
                    valSa: 'श्री ${panchang.samvatsaraSa} संवत्सरे',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildParamTile(
                    icon: '☀️',
                    labelTe: 'ఆయనం • ఋతువు',
                    valTe: '${panchang.ayanaTe} • ${panchang.rithuTe}',
                    valSa: '${panchang.ayanaSa} • ${panchang.rithuSa}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 2: Masam & Paksham
            Row(
              children: [
                Expanded(
                  child: _buildParamTile(
                    icon: '🌙',
                    labelTe: 'మాసం (Month)',
                    valTe: '${panchang.masaTe} మాసం',
                    valSa: '${panchang.masaSa} मासे',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildParamTile(
                    icon: '🌓',
                    labelTe: 'పక్షం (Fortnight)',
                    valTe: panchang.pakshaTe,
                    valSa: panchang.pakshaSa,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 3: Tithi & Varam
            Row(
              children: [
                Expanded(
                  child: _buildParamTile(
                    icon: '🌸',
                    labelTe: 'తిథి (Lunar Day)',
                    valTe: panchang.tithiTe,
                    valSa: panchang.tithiSa,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildParamTile(
                    icon: '📿',
                    labelTe: 'వారం (Weekday)',
                    valTe: panchang.vasaraTe,
                    valSa: panchang.vasaraSa,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 4: Nakshatram (Highlight Full Width Tile)
            _buildParamTile(
              icon: '✨',
              labelTe: 'నక్షత్రం (Constellation)',
              valTe: '${panchang.nakshatraTe} నక్షత్రం',
              valSa: '${panchang.nakshatraSa} नक्षत्रे',
              isFullWidth: true,
            ),
            const SizedBox(height: 10),

            // 3. Auspicious Timings Ribbon (రాహుకాలం & యమగండం)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isGlassmorphic ? Colors.amber.shade900.withValues(alpha: 0.28) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isGlassmorphic ? Colors.amber.shade400.withValues(alpha: 0.4) : const Color(0xFFFDE68A),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⏰ ', style: TextStyle(fontSize: 13)),
                  Flexible(
                    child: Text(
                      'రాహుకాలం: ${panchang.rahuKalam}   |   యమగండం: ${panchang.yamagandam}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isGlassmorphic ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 4. View Personalized Live Sankalpam Button
            ElevatedButton.icon(
              onPressed: () => _showFullSankalpamModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isGlassmorphic ? const Color(0xFFD97706) : AppTypography.primaryMaroon,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                elevation: isGlassmorphic ? 3 : 1.5,
                shadowColor: isGlassmorphic ? const Color(0xFFD97706).withValues(alpha: 0.5) : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Text('📜', style: TextStyle(fontSize: 17)),
              label: const Text(
                'సంపూర్ణ పూజా సంకల్ప మంత్రం చూడండి ➔',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        );

    if (isGlassmorphic) {
      return SacredGlassCard(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        borderColor: Colors.white.withValues(alpha: 0.22),
        child: content,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTypography.cardSurfaceWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.shade900.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: content,
      ),
    );
  }

  Widget _buildParamTile({
    required String icon,
    required String labelTe,
    required String valTe,
    required String valSa,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isGlassmorphic ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isGlassmorphic ? Colors.white.withValues(alpha: 0.16) : const Color(0xFFFDE68A),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isGlassmorphic ? 0.08 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with tiny icon
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  labelTe,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isGlassmorphic ? Colors.white70 : AppTypography.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          // Main Telugu Value
          Text(
            valTe,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: isGlassmorphic ? Colors.white : AppTypography.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          // Sanskrit Script Term
          Text(
            valSa,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isGlassmorphic ? const Color(0xFFFDE68A) : AppTypography.primaryMaroon,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// సంపూర్ణ సంకల్ప బాటమ్ షీట్ (Full Live Personalized Sankalpam Bottom Sheet)
class _FullSankalpamSheet extends StatefulWidget {
  final DevoteeProfile profile;
  final PanchangamData panchang;
  final DateTime selectedDate;
  final VoidCallback onEditProfile;

  const _FullSankalpamSheet({
    Key? key,
    required this.profile,
    required this.panchang,
    required this.selectedDate,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  __FullSankalpamSheetState createState() => __FullSankalpamSheetState();
}

class __FullSankalpamSheetState extends State<_FullSankalpamSheet> {
  String _activeScript = 'telugu';

  @override
  Widget build(BuildContext context) {
    final sankalpaMap = DynamicSankalpamService.generateBilingualSankalpam(
      profile: widget.profile,
      panchang: widget.panchang,
      deityNameTe: 'శ్రీ అయ్యప్పస్వామి సమస్త దేవతా',
      deityNameSa: 'श्री अय्यप्पस्वामी समस्त देवता',
    );

    final currentText = _activeScript == 'telugu'
        ? sankalpaMap['telugu']!
        : sankalpaMap['sanskrit']!;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Sheet Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  const Text('🕉️ ', style: TextStyle(fontSize: 22)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ప్రత్యక్ష ద్రిక-సిద్ధాంత సంకల్పం',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTypography.primaryMaroon,
                          ),
                        ),
                        Text(
                          '${PanchangamService.formatTeluguDate(widget.selectedDate)} • ${widget.profile.gotram} గోత్రం',
                          style: const TextStyle(fontSize: 12, color: AppTypography.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Family summary badge & Edit button
            Container(
              margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '🙏 ${widget.profile.gotram} గోత్రం • ${widget.profile.kartaName} & ${widget.profile.spouseName} (${widget.profile.childrenNames})',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTypography.primaryMaroon,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.onEditProfile();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: const [
                          Icon(Icons.edit, size: 14, color: AppTypography.templeDeepOrange),
                          SizedBox(width: 3),
                          Text('సవరించు', style: TextStyle(fontSize: 11.5, color: AppTypography.templeDeepOrange, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dual Language Toggle Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeScript = 'telugu'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _activeScript == 'telugu'
                              ? AppTypography.primaryMaroon
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'తెలుగు లిపి (Telugu)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _activeScript == 'telugu' ? Colors.white : AppTypography.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeScript = 'sanskrit'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _activeScript == 'sanskrit'
                              ? AppTypography.primaryMaroon
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'संस्कृतम् (Devanagari)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _activeScript == 'sanskrit' ? Colors.white : AppTypography.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Personalized Sankalpam Text
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                  ),
                  child: SelectableText(
                    currentText,
                    style: _activeScript == 'telugu'
                        ? AppTypography.teluguSloka(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                            height: 1.8,
                          )
                        : AppTypography.sanskritSloka(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                            height: 1.75,
                          ),
                  ),
                ),
              ),
            ),

            // Bottom Actions: Copy & Close
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: currentText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('సంకల్ప మంత్రం కాపీ చేయబడింది!'),
                            backgroundColor: AppTypography.primaryMaroon,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTypography.primaryMaroon,
                        side: const BorderSide(color: AppTypography.primaryMaroon),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('మంత్రం కాపీ చేయి', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTypography.primaryMaroon,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('సరే (Close)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
