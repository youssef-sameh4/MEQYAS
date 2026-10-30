
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/Widgets/PowerFactorCard.dart';
import 'package:meqyas/Widgets/quickActins.dart';
import 'package:meqyas/Widgets/text_feild.dart';
import 'package:meqyas/Widgets/Cards.dart';

import 'package:meqyas/feature/pages/AiEnergyAnalysisContent.dart';
import 'package:meqyas/feature/pages/AlertsPage.dart';

import 'package:meqyas/feature/pages/Recommendations.dart';
import 'package:meqyas/feature/pages/Reports.dart';


class HomePage extends StatelessWidget {
  final String factoryName;
  final String factoryAddress;

  // الانتقال إلى التبويبات الأساسية
  final void Function(int index) onNavigateToTab;

  // فتح Reports و AI Analysis مع الاحتفاظ بالـ Navbar
  final void Function(Widget screen) onOpenExtraScreen;

  const HomePage({
    super.key,
    required this.factoryName,
    required this.factoryAddress,
    required this.onNavigateToTab,
    required this.onOpenExtraScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/photo_2026-10-17_13-24-57.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/MEQYAS_logo_transparent 1.png',
                            height: 36,
                            width: 135,
                          ),
                          const SizedBox(height: 3),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () => onOpenExtraScreen(const AlertsPage()),
                      child: _headerIcon(Icons.notifications_none),
                    ),

                    const SizedBox(width: 12),
                    InkWell

                      (
                        onTap: () => onNavigateToTab(4),

                        child: _headerIcon(Icons.account_circle_outlined)),
                  ],
                ),

                const SizedBox(height: 20),

                // FACTORY INFORMATION
                card(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Appcolor.leafcolor,
                        child: Image.asset('assets/Vector (14).png'),
                      ),
                      const SizedBox(width: 21),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              factoryName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              factoryAddress,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ENERGY OVERVIEW
                sectionTitle('Energy Overview'),
                const SizedBox(height: 12),

                // STATISTICS ROW 1
                Row(
                  children: [
                    Expanded(
                      child: statCard(
                        CircleAvatarcolor: Appcolor.blueColor,
                        title: 'Total Consumption',
                        value: '1,240 kWh',
                        color: Appcolor.black,
                        iconimage: 'assets/Vector (13).png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: statCard(
                        color2: Colors.red,
                        image1: 'assets/Vector (10).png',
                        image2: 'assets/Vector (11).png',
                        CircleAvatarcolor: Appcolor.darkdarkblue,
                        title: 'Total Cost',
                        value: 'EGP 12,400',
                        color: Appcolor.pink,
                        iconimage: 'assets/Group (2).png',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // STATISTICS ROW 2
                Row(
                  children: [
                    Expanded(
                      child: statCard(
                        CircleAvatarcolor: Appcolor.lightgreen,
                        title: '850 Units',
                        value: '',
                        color: Appcolor.green,
                        iconimage: 'assets/Group (1).png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: statCard(
                        CircleAvatarcolor: Appcolor.lightgreen,
                        title: 'Total Energy',
                        value: '1.6 kWh',
                        color: Appcolor.leafcolor,
                        iconimage: 'assets/Vector (12).png',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                card(child: HomeCard()),

                const SizedBox(height: 18),


                generalHomeCard(
                  Title: 'Active Anomalies',
                  Subtext: '5',
                  icon: Icons.crop_square_outlined,
                  iconcolor: Colors.red,
                  ontap: () => onNavigateToTab(2),
                  IconImage: 'assets/Group.png',
                  cyrcleavatarcolor: Appcolor.pink,
                ),

                const SizedBox(height: 12),


                generalHomeCard(
                  Title: 'Potential Monthly Savings',
                  Subtext: 'Based on Current Recommendations',
                  icon: Icons.savings_outlined,
                  iconcolor: Appcolor.green,
                  price: 'EGP 45,000',
                  IconImage: 'assets/Group (3).png',
                  cyrcleavatarcolor: Appcolor.green,
                  ontap: () {
                    onOpenExtraScreen(RecommendationsScreen());
                  },
                ),

                const SizedBox(height: 12),

                // AI ENERGY INSIGHTS
                generalHomeCard(
                  Title: 'AI Energy Insights',
                  Subtext:
                  'Energy consumption increased by 12% compared to\n'
                      'previous period. the main contributing factor appears to\n'
                      'be higher operayion hours',
                  icon: Icons.auto_awesome,
                  iconcolor: Appcolor.green,
                  ontap: () => onNavigateToTab(3),
                  IconImage: 'assets/arcticons_ai-score.png',
                  cyrcleavatarcolor: Appcolor.green,
                ),
                const SizedBox(height: 12),
                PowerFactorCard(
                  onOpenExtraScreen: (Widget screen) {
                    onOpenExtraScreen(screen);
                  },
                ),

                const SizedBox(height: 20),

                // QUICK ACTIONS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xD90C2748),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle('Quick Actions'),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          // VIEW ANALYTICS
                          Expanded(
                            child: quickAction(
                              title: 'View',
                              subtitle: 'Analytics',
                              color: Appcolor.lightBlue,
                              onTap: () => onNavigateToTab(1),
                              ImageIcon: 'assets/Vector (15).png',
                            ),
                          ),

                          // GENERATE REPORT
                          Expanded(
                            child: quickAction(
                              title: 'Generate',
                              subtitle: 'Report',
                              color: Appcolor.green,
                              onTap: () {
                                onOpenExtraScreen(ReportsScreen());
                              },
                              ImageIcon:
                              'assets/boxicons_file-report.png',
                            ),
                          ),

                          // WHAT-IF SIMULATOR
                          Expanded(
                            child: quickAction(
                              title: 'What-if',
                              subtitle: 'Simulator',
                              color: const Color(0xFF8CB8FF),
                              onTap: () => onNavigateToTab(5),
                              ImageIcon: 'assets/Vector (17).png',
                            ),
                          ),

                          // SETTINGS
                          Expanded(
                            child: quickAction(
                              title: 'Settings',
                              subtitle: '',
                              color: const Color(0xFF9AB6D8),
                              onTap: () => onNavigateToTab(4),
                              ImageIcon:
                              'assets/ant-design_setting-outlined.png',
                            ),
                          ),

                          // VIEW ANOMALIES
                          Expanded(
                            child: quickAction(
                              title: 'View',
                              subtitle: 'Anomalies',
                              color: const Color(0xFFFF7777),
                              onTap: () => onNavigateToTab(2),
                              ImageIcon:
                              'assets/ant-design_warning-twotone.png',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // AI ANALYSIS CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1264AA),
                        Color(0xFF052541),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF1676B8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF062D50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/AI analytics illustration.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Analysis Completed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'The AI analysis has been completed '
                                      'successfully using the demo dataset.',
                                  style: TextStyle(
                                    color: Color(0xFFB4C9DD),
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            onOpenExtraScreen(
                              AiEnergyAnalysisContent(),
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Run AI Analysis'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0788FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _headerIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Appcolor.cardBlue.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 21,
      ),
    );
  }

  static void _showAction(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title selected'),
        backgroundColor: Appcolor.cardBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
