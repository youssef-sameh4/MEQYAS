
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/feature/pages/AlertsPage.dart';
import 'package:meqyas/feature/pages/Anomaly%20Details.dart';

class AnomaliesScreen extends StatefulWidget {
  const AnomaliesScreen({super.key});

  @override
  State<AnomaliesScreen> createState() => _AnomaliesScreenState();
}

class _AnomaliesScreenState extends State<AnomaliesScreen> {
  int selectedFilter = 0;

  static const List<String> filters = [
    'All (5)',
    'Low (1)',
    'High (2)',
    'Medium (2)',
  ];

  static const List<Anomaly> anomalies = [
    Anomaly(
      id: 'compressor_high_001',
      title: 'Unusual high consumption',
      location: 'Compressor system',
      date: 'Aug 14, 2025',
      level: AnomalyLevel.high,
      color: Color(0xFFFF555D),

      detailsScreen: AnomalyDetailsScreen(),
      IconImage: 'assets/⦿.png',
    ),
    Anomaly(
      id: 'packaging_high_002',
      title: 'High night consumption',
      location: 'Packaging line',
      date: 'Aug 12, 2025',
      level: AnomalyLevel.high,
      color: Color(0xFFFF555D),
      IconImage: "assets/⦿.png",
      detailsScreen: null,
    ),
    Anomaly(
      id: 'production_medium_003',
      title: 'Energy intensity increase',
      location: 'Production line 2',
      date: 'Aug 10, 2025',
      level: AnomalyLevel.medium,
      color: Color(0xFFFFB547),

      detailsScreen: null, IconImage: 'assets/⦿ (2).png',
    ),
    Anomaly(
      id: 'utilities_medium_004',
      title: 'Unexpected consumption',
      location: 'Utilities',
      date: 'Aug 08, 2025',
      level: AnomalyLevel.medium,
      color: Color(0xFFFFB547),

      detailsScreen: null, IconImage: 'assets/⦿ (2).png',
    ),
    Anomaly(
      id: 'compressor_low_005',
      title: 'Unusual high consumption',
      location: 'Compressor system',
      date: 'Aug 05, 2025',
      level: AnomalyLevel.low,
      color: Color(0xFF478BFF),

      detailsScreen: null, IconImage: 'assets/⦿ (3).png',
    ),
  ];

  AnomalyLevel? get selectedLevel {
    switch (selectedFilter) {
      case 1:
        return AnomalyLevel.low;
      case 2:
        return AnomalyLevel.high;
      case 3:
        return AnomalyLevel.medium;
      default:
        return null;
    }
  }

  List<Anomaly> get filteredAnomalies {
    final level = selectedLevel;

    if (level == null) {
      return anomalies;
    }

    return anomalies
        .where((anomaly) => anomaly.level == level)
        .toList(growable: false);
  }

  void _openAnomaly(BuildContext context, Anomaly anomaly) {
    final screen = anomaly.detailsScreen;

    if (screen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details screen is not available yet.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedAnomalies = filteredAnomalies;

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
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    8,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Anomalies List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AlertsPage(),
                            ),
                          );
                        },
                        child: headerIcon(Icons.notifications_none),
                      ),
                      SizedBox(width: 10,),
                      _HeaderButton(
                        icon: Icons.search,
                        onTap: () {
                          // Add search functionality here.
                        },
                      ),
                      const SizedBox(width: 10),
                      _HeaderButton(
                        icon: Icons.tune,
                        onTap: () {
                          // Add advanced filters here.
                        },
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Monitor unusual energy consumption',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Filters
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return _FilterItem(
                        title: filters[index],
                        selected: selectedFilter == index,
                        onTap: () {
                          if (selectedFilter == index) return;

                          setState(() {
                            selectedFilter = index;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Anomaly list
                Expanded(
                  child: displayedAnomalies.isEmpty
                      ? const Center(
                    child: Text(
                      'No anomalies found',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      4,
                      12,
                      20,
                    ),
                    itemCount: displayedAnomalies.length,
                    itemBuilder: (context, index) {
                      final anomaly = displayedAnomalies[index];

                      return _AnomalyCard(
                        key: ValueKey(anomaly.id),
                        anomaly: anomaly,
                        onTap: () =>
                            _openAnomaly(context, anomaly),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Anomaly model
// --------------------------------------------------

enum AnomalyLevel {
  low,
  high,
  medium,
}

class Anomaly {
  final String id;
  final String title;
  final String location;
  final String date;
  final AnomalyLevel level;
  final Color color;
final String IconImage;
  final Widget? detailsScreen;

  const Anomaly({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.level,
    required this.color,
    this.detailsScreen,
    required this.IconImage,
  });
}

// --------------------------------------------------
// Header button
// --------------------------------------------------

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF102D50),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Filter item
// --------------------------------------------------

class _FilterItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Appcolor.blueColor.withOpacity(0.2)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: selected
                  ? Appcolor.greenColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Appcolor.greenColor
                : Colors.white70,
            fontSize: 11,
            fontWeight:
            selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Anomaly card
// --------------------------------------------------

class _AnomalyCard extends StatelessWidget {
  final Anomaly anomaly;
  final VoidCallback onTap;

  const _AnomalyCard({
    super.key,
    required this.anomaly,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1763B8),
            Color(0xFF10345E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: anomaly.color.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Image.asset(
                    anomaly.IconImage,
                    color: anomaly.color,

                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anomaly.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        anomaly.location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        anomaly.date,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: anomaly.color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    _levelLabel(anomaly.level),
                    style: TextStyle(
                      color: anomaly.color,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 3),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _levelLabel(AnomalyLevel level) {
    switch (level) {
      case AnomalyLevel.low:
        return 'Low';
      case AnomalyLevel.high:
        return 'High';
      case AnomalyLevel.medium:
        return 'Medium';
    }
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