
import 'package:flutter/material.dart';

class AvailableReportsScreen extends StatelessWidget {
  const AvailableReportsScreen({super.key});

  static const Color backgroundColor = Color(0xFF071D35);
  static const Color cardTopColor = Color(0xFF15518D);
  static const Color cardBottomColor = Color(0xFF0A315C);
  static const Color accentColor = Color(0xFF00D9F5);

  static const List<Map<String, dynamic>> reports = [
    {
      'title': 'Executive Summary',
      'description': 'Performance, observations and next steps.',
      'icon': Icons.description_outlined,
    },
    {
      'title': 'Energy Consumption Analysis',
      'description': 'Consumption comparisons and energy intensity.',
      'icon': Icons.trending_up_rounded,
    },
    {
      'title': 'Financial Impact Report',
      'description': 'Illustrative financial estimates and their scope.',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Anomaly Report',
      'description': 'Observations that require further review.',
      'icon': Icons.warning_amber_rounded,
    },
    {
      'title': 'Recommendations Report',
      'description': 'Prioritized opportunities and implementation status.',
      'icon': Icons.assignment_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background image placeholder
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1516937941344-00b4e0337589'
                  '?auto=format&fit=crop&w=900&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              color: const Color(0xE6071D35),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'Available Reports',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    ],
                  ),
                ),

                // Reports list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                    itemCount: reports.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final report = reports[index];

                      return _ReportCard(
                        title: report['title'] as String,
                        description: report['description'] as String,
                        icon: report['icon'] as IconData,
                        onDownload: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${report['title']} selected',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Bottom actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Generate PDF'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF087CF5),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: const Color(0xFF087CF5)
                                .withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Generate PDF',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      SizedBox(
                        width: double.infinity,
                        height: 39,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Export Excel'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF07365F),
                            foregroundColor: accentColor,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Export Excel',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 90,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onDownload;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF175A9B),
            Color(0xFF0C3158),
          ],
        ),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFF5AA9FF).withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF00D9F5),
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDownload,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.file_download_outlined,
                    color: Color(0xFF00D9F5),
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFB8C9DD),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aug 2024 · Sample prototype data',
            style: TextStyle(
              color: Color(0xFF829DBB),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
