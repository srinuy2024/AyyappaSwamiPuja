// lib/screens/main_navigation_screen.dart
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
      body: IndexedStack(
        index: _currentIndex,
        children: chambers,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.amber.shade200, width: 1.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFEF3C7),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.temple_hindu_outlined, color: AppTypography.primaryMaroon),
              selectedIcon: Icon(Icons.temple_hindu, color: AppTypography.primaryMaroon),
              label: 'మందిరం',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined, color: Color(0xFFB91C1C)),
              selectedIcon: Icon(Icons.auto_awesome, color: Color(0xFFB91C1C)),
              label: 'పూజలు & వ్రతాలు',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined, color: Color(0xFF0D9488)),
              selectedIcon: Icon(Icons.menu_book, color: Color(0xFF0D9488)),
              label: 'జ్ఞాన నిధి',
            ),
            NavigationDestination(
              icon: Icon(Icons.self_improvement_outlined, color: Color(0xFF7C3AED)),
              selectedIcon: Icon(Icons.self_improvement, color: Color(0xFF7C3AED)),
              label: 'నిత్య సాధన',
            ),
          ],
        ),
      ),
    );
  }
}
