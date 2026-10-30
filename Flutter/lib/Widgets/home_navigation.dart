
import 'package:flutter/material.dart';

import 'package:meqyas/feature/pages/Homepage.dart';
import 'package:meqyas/feature/pages/ai_energy_insights.dart';
import 'package:meqyas/feature/pages/analytics_screen.dart';
import 'package:meqyas/feature/pages/anomalies_screen.dart';
import 'package:meqyas/feature/pages/settings.dart';
import 'package:meqyas/feature/pages/simulator.dart';

class HomeNavigation extends StatefulWidget {
  final String factoryName;
  final String factoryAddress;

  const HomeNavigation({
    super.key,
    required this.factoryName,
    required this.factoryAddress,
  });

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int currentIndex = 0;

  // Navigator منفصل لكل تبويب.
  // الصفحات الفرعية تفتح داخله، لذلك الـ Navbar يظل ظاهرًا.
  final List<GlobalKey<NavigatorState>> _navigatorKeys =
  List.generate(
    6,
        (_) => GlobalKey<NavigatorState>(),
  );

  late final List<Widget> screens = [
    HomePage(
      factoryName: widget.factoryName,
      factoryAddress: widget.factoryAddress,
      onNavigateToTab: _selectTab,
      onOpenExtraScreen: _openExtraScreen,
    ),
    const AnalyticsScreen(),
    const AnomaliesScreen(),
    const AiEnergyInsights(),
    const ProfileSettingsScreen(),
    const WhatIfSimulatorScreen(),
  ];

  // فتح التبويب المطلوب.
  void _selectTab(int index) {
    if (index < 0 || index >= screens.length) return;

    // عند اختيار تبويب، نرجع لصفحته الرئيسية.
    _navigatorKeys[index].currentState?.popUntil(
          (route) => route.isFirst,
    );

    setState(() {
      currentIndex = index;
    });
  }

  // فتح صفحة فرعية داخل Navigator الخاص بالـ Home.
  void _openExtraScreen(Widget screen) {
    _navigatorKeys[0].currentState?.push(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  // بناء Navigator مستقل لكل تبويب.
  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => screens[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 6;

    return Scaffold(
      backgroundColor: const Color(0xFF07182F),
      body: Stack(
        children: [
          // محتوى التبويبات والصفحات الفرعية.
          Positioned.fill(
            child: IndexedStack(
              index: currentIndex,
              children: List.generate(
                screens.length,
                    (index) => _buildTabNavigator(index),
              ),
            ),
          ),

          // Bottom Navigation Bar ثابت فوق المحتوى.
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 85,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 22),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0C2748),
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFF183B60),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        buildItem(
                          Icons.home_rounded,
                          'Home',
                          0,
                        ),
                        buildItem(
                          Icons.analytics_outlined,
                          'Analytics',
                          1,
                        ),
                        buildItem(
                          Icons.notifications_none,
                          'Anomalies',
                          2,
                        ),
                        buildItem(
                          Icons.auto_awesome,
                          'AI',
                          3,
                        ),
                        buildItem(
                          Icons.settings_outlined,
                          'Settings',
                          4,
                        ),
                        buildItem(
                          Icons.align_vertical_center_rounded,
                          'Simulator',
                          5,
                        ),
                      ],
                    ),
                  ),

                  // الأيقونة المتحركة.
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    top: 0,
                    left:
                    itemWidth * currentIndex +
                        (itemWidth - 54) / 2,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0878F9),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF07182F),
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        _getIconForIndex(currentIndex),
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.analytics_outlined;
      case 2:
        return Icons.notifications_none;
      case 3:
        return Icons.auto_awesome;
      case 4:
        return Icons.settings_outlined;
      default:
        return Icons.align_vertical_center_rounded;
    }
  }

  Widget buildItem(
      IconData icon,
      String title,
      int index,
      ) {
    final selected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _selectTab(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: selected ? 0 : 1,
                child: Icon(
                  icon,
                  color: Colors.white70,
                  size: 19,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF13D99A)
                      : Colors.white70,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
