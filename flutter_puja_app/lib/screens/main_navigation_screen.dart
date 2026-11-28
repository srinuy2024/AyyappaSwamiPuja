// lib/screens/main_navigation_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_typography.dart';
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
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 14 : 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: accentColor.withValues(alpha: 0.6), width: 1.0)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
              color: isSelected ? accentColor : Colors.grey.shade700,
            ),
            if (isSelected) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
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
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.shade900.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.temple_hindu_outlined, Icons.temple_hindu, 'మందిరం', AppTypography.primaryMaroon),
                    _buildNavItem(1, Icons.auto_awesome_outlined, Icons.auto_awesome, 'పూజలు', const Color(0xFFB91C1C)),
                    _buildNavItem(2, Icons.menu_book_outlined, Icons.menu_book, 'జ్ఞాన నిధి', const Color(0xFF0D9488)),
                    _buildNavItem(3, Icons.self_improvement_outlined, Icons.self_improvement, 'సాధన', const Color(0xFF7C3AED)),
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
