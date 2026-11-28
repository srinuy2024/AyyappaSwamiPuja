// lib/screens/main_navigation_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../services/panchangam_service.dart';
import 'home_screen.dart';
import 'pujas_hub_screen.dart';
import 'jnana_library_screen.dart';
import 'sadhana_hub_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  DevoteeProfile _profile = DevoteeProfile();
  late PanchangamData _panchang;

  @override
  void initState() {
    super.initState();
    _panchang = PanchangamService.calculate(DateTime.now());
    DevoteeProfile.loadFromPrefs().then((p) {
      if (mounted) setState(() => _profile = p);
    });
  }

  void _onTabTapped(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, Color accentColor) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 14 : 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? Border.all(color: accentColor.withValues(alpha: 0.55), width: 1.0)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
              color: isSelected ? accentColor : Colors.white70,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> chambers = [
      HomeScreen(
        onNavigateToTab: (tabIndex) => _onTabTapped(tabIndex),
      ),
      PujasHubScreen(profile: _profile, panchang: _panchang),
      const JnanaLibraryScreen(),
      SadhanaHubScreen(profile: _profile),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: chambers,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.amber.shade900.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF130B24).withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.temple_hindu_outlined, Icons.temple_hindu, 'మందిరం', const Color(0xFFF59E0B)),
                    _buildNavItem(1, Icons.auto_awesome_outlined, Icons.auto_awesome, 'పూజలు', const Color(0xFFEF4444)),
                    _buildNavItem(2, Icons.menu_book_outlined, Icons.menu_book, 'జ్ఞాన నిధి', const Color(0xFF14B8A6)),
                    _buildNavItem(3, Icons.self_improvement_outlined, Icons.self_improvement, 'సాధన', const Color(0xFFA855F7)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
