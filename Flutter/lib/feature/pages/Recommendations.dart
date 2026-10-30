
import 'package:flutter/material.dart';
import 'package:meqyas/feature/pages/Recommendation_Details.dart';


class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> recommendations = [
    {
      'title': 'Optimize Compressed-Air Systems',
      'category': 'Energy Efficiency',
      'priority': 'Medium-High',
      'description':
      'Identify and fix compressed-air leaks to reduce energy waste and operating costs.',
      'saving': '45,000',
      'unit': '/year',
      'impact': '12% potential energy reduction',
      'status': 'Recommended action',
      'level': 1,
      'why':
      'Compressed-air leaks can waste a significant amount of energy. Identifying and repairing leaks can reduce electricity consumption and improve system efficiency.',
      'actionSteps': [
        'Inspect compressed-air lines for leaks',
        'Repair identified leaks',
        'Review pressure settings',
        'Measure energy consumption',
        'Verify savings after implementation',
      ],
    },
    {
      'title': 'Adjust Production Schedule',
      'category': 'Operational Efficiency',
      'priority': 'High',
      'description':
      'Optimize production timing to reduce energy consumption during peak-demand periods.',
      'saving': '30,000',
      'unit': '/year',
      'impact': 'Reduced peak energy demand',
      'status': 'Coming soon',
      'level': 2,
      'why':
      'Adjusting production schedules can help reduce peak-demand charges and improve energy usage.',
      'actionSteps': [
        'Review the current production schedule',
        'Identify peak-demand periods',
        'Adjust production timing',
        'Monitor energy consumption',
      ],
    },
    {
      'title': 'HVAC Temperature Optimization',
      'category': 'Energy Efficiency',
      'priority': 'Medium',
      'description':
      'Optimize heating and cooling temperature settings to avoid unnecessary energy consumption.',
      'saving': '25,000',
      'unit': '/year',
      'impact': 'Improved HVAC efficiency',
      'status': 'Coming soon',
      'level': 3,
      'why':
      'Appropriate temperature settings can reduce HVAC energy consumption while maintaining comfort.',
      'actionSteps': [
        'Review current temperature settings',
        'Identify suitable temperature ranges',
        'Adjust HVAC controls',
        'Track energy consumption',
      ],
    },
    {
      'title': 'Lighting System Upgrade',
      'category': 'Energy Efficiency',
      'priority': 'Low',
      'description':
      'Replace inefficient lighting with energy-efficient LED alternatives.',
      'saving': '18,000',
      'unit': '/year',
      'impact': 'Lower lighting energy consumption',
      'status': 'Coming soon',
      'level': 4,
      'why':
      'LED lighting typically uses less electricity and can reduce maintenance requirements.',
      'actionSteps': [
        'Inspect existing lighting systems',
        'Identify inefficient lights',
        'Evaluate LED alternatives',
        'Install suitable replacements',
        'Compare energy usage before and after',
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredRecommendations {
    if (selectedFilter == 'All') {
      return recommendations;
    }

    if (selectedFilter == 'High Priority') {
      return recommendations
          .where((item) =>
      item['priority'] == 'High' ||
          item['priority'] == 'Medium-High')
          .toList();
    }

    if (selectedFilter == 'Medium Priority') {
      return recommendations
          .where((item) => item['priority'] == 'Medium')
          .toList();
    }

    if (selectedFilter == 'Low Priority') {
      return recommendations
          .where((item) => item['priority'] == 'Low')
          .toList();
    }

    return recommendations;
  }

  void openRecommendation(Map<String, dynamic> item) {
    // Only the first recommendation is enabled for now.
    if (item['level'] != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Details for this recommendation are coming soon.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationDetailsScreen(
          recommendation: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF101820);
    const cardColor = Color(0xFF1B2733);
    const accentColor = Color(0xFF35D0BA);
    const secondaryText = Color(0xFF9EADB9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recommendations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                'Energy-saving opportunities',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),
            ),

            // Summary cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total',
                      value: '${recommendations.length}',
                      subtitle: 'Recommendations',
                      icon: Icons.lightbulb_outline,
                      accentColor: accentColor,
                      cardColor: cardColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _SummaryCard(
                      title: 'Potential Savings',
                      value: 'EGP 118K',
                      subtitle: 'Estimated / year',
                      icon: Icons.trending_down,
                      accentColor: accentColor,
                      cardColor: cardColor,
                    ),
                  ),
                ],
              ),
            ),

            // Filters
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  'All',
                  'High Priority',
                  'Medium Priority',
                  'Low Priority',
                ].map((filter) {
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: accentColor,
                      backgroundColor: cardColor,
                      labelStyle: TextStyle(
                        color: isSelected ? backgroundColor : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? accentColor
                            : Colors.white12,
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Recommendations list
            Expanded(
              child: filteredRecommendations.isEmpty
                  ? const Center(
                child: Text(
                  'No recommendations found.',
                  style: TextStyle(color: secondaryText),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: filteredRecommendations.length,
                itemBuilder: (context, index) {
                  final item = filteredRecommendations[index];

                  return _RecommendationCard(
                    recommendation: item,
                    onTap: () => openRecommendation(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color cardColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 23),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9EADB9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF9EADB9),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  Color get priorityColor {
    switch (recommendation['priority']) {
      case 'High':
        return const Color(0xFFFF7777);
      case 'Medium-High':
        return const Color(0xFFFFB45C);
      case 'Medium':
        return const Color(0xFFFFD166);
      default:
        return const Color(0xFF79D6A5);
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF35D0BA);
    const cardColor = Color(0xFF1B2733);
    const secondaryText = Color(0xFF9EADB9);

    final bool isEnabled = recommendation['level'] == 1;

    return Card(
      color: cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isEnabled ? accentColor.withValues(alpha: 0.35) : Colors.white10,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recommendation['category'],
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isEnabled ? Icons.arrow_forward_ios : Icons.lock_outline,
                    color: isEnabled ? accentColor : secondaryText,
                    size: 16,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                recommendation['description'],
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoTag(
                    icon: Icons.flag_outlined,
                    text: recommendation['priority'],
                    color: priorityColor,
                  ),
                  _InfoTag(
                    icon: Icons.savings_outlined,
                    text: 'EGP ${recommendation['saving']}${recommendation['unit']}',
                    color: accentColor,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.eco_outlined,
                      color: accentColor,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation['impact'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isEnabled ? accentColor : secondaryText,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      isEnabled
                          ? recommendation['status']
                          : 'Details coming soon',
                      style: TextStyle(
                        color: isEnabled ? accentColor : secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    isEnabled ? 'View details' : 'Unavailable',
                    style: TextStyle(
                      color: isEnabled ? accentColor : secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoTag({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
