
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/feature/pages/AlertsPage.dart';
import 'package:meqyas/feature/pages/Ask%20ai.dart';
import 'package:meqyas/feature/pages/Recommendations.dart';

const Color _bg = Color(0xFF061A34);
const Color _panel = Color(0xFF0A2A50);
const Color _card = Color(0xFF0C2B4D);
const Color _border = Color(0xFF17466E);
const Color _blue = Color(0xFF087CFF);
const Color _cyan = Color(0xFF27DDF0);
const Color _white = Color(0xFFF1F6FF);
const Color _muted = Color(0xFF91A9C3);
const Color _green = Color(0xFF39D8AE);
const Color _orange = Color(0xFFFFC45C);

class AiEnergyInsights extends StatefulWidget {
  const AiEnergyInsights({super.key});

  @override
  State<AiEnergyInsights> createState() => _AiEnergyInsightsState();
}

class _AiEnergyInsightsState extends State<AiEnergyInsights> {
  int _selectedTab = 0;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _panel,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF08264B),
              Color(0xFF061A34),
              Color(0xFF03142A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 17),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AI Energy Insights',
                          style: TextStyle(
                            color: _white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),

                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const AlertsPage(),
                              ),
                            );
                          },
                          child: headerIcon(
                            Icons.notifications_none,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Understand what is driving your energy performance.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 13),

                    Row(
                      children: [
                        _tabButton('Insights', 0),
                        const SizedBox(width: 7),
                        _tabButton('Ask AI', 1),
                      ],
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // Content for the selected tab
              Expanded(
                child: _selectedTab == 0
                    ? SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      14, 0, 14, 16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      _executiveSummary(),

                      const SizedBox(height: 15),

                      _sectionTitle(
                        Icons.insights_outlined,
                        'Key Insights',
                      ),

                      const SizedBox(height: 8),

                      _insightCard(
                        icon: Icons.access_time_rounded,
                        title: 'Peak-Hour Consumption',
                        description:
                        'Energy consumption is significantly higher '
                            'during peak operating hours.',
                        tag: 'Review',
                        tagColor: _cyan,
                      ),

                      _insightCard(
                        icon: Icons.bolt,
                        title: 'Energy Intensity Change',
                        description:
                        'Energy consumed per unit of production '
                            'increased compared with the baseline.',
                        tag: 'Attention',
                        tagColor: _orange,
                      ),

                      _insightCard(
                        icon: Icons.insert_chart_outlined,
                        title: 'Production Comparison',
                        description:
                        'Production increased by 3%, while energy '
                            'consumption increased by 12%.',
                        tag: 'Data Insight',
                        tagColor: _cyan,
                      ),

                      const SizedBox(height: 9),

                      _sectionTitle(
                        Icons.checklist_rounded,
                        'Recommended Next Steps',
                      ),

                      const SizedBox(height: 8),

                      _recommendations(),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 39,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecommendationsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                'View Recommendations',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(
                                Icons.arrow_forward,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'AI insights are based on the available factory '
                            'data and should be reviewed before taking action.',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 8,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
                    : const AiCopilotScreen(),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final selected = _selectedTab == index;

    return InkWell(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AiCopilotScreen(),
            ),
          );
        } else {
          setState(() => _selectedTab = index);
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF0A405E)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? _cyan : _border,
            width: 0.8,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? _cyan : _muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: _cyan, size: 14),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: _white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _executiveSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: _border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.auto_awesome,
            'Executive Summary',
          ),

          const SizedBox(height: 8),

          const Text(
            'Energy consumption increased by 12% compared with '
                'the previous period, while production increased by only 3%. '
                'This may indicate increased energy intensity and '
                'opportunities for improving efficiency.',
            style: TextStyle(
              color: _white,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 10),

          const Divider(
            color: _border,
            height: 1,
          ),

          const SizedBox(height: 9),

          const Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Consumption',
                  value: '+12%',
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Production',
                  value: '+3%',
                  color: _cyan,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFF0B3551),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: _green,
                  size: 12,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Based on available factory data',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard({
    required IconData icon,
    required String title,
    required String description,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _border,
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _cyan, size: 13),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: const TextStyle(
              color: _muted,
              fontSize: 8,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: tagColor.withOpacity(0.3),
                width: 0.6,
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: tagColor,
                fontSize: 7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendations() {
    final items = [
      'Review operating schedules during peak hours.',
      'Inspect compressed-air systems if applicable.',
      'Compare consumption during peak and off-peak periods.',
      'Validate the observations against production records.',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.7),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B3C5C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: _cyan,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    items[index],
                    style: const TextStyle(
                      color: _white,
                      fontSize: 8,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

Widget headerIcon(IconData icon) {
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
