
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Color backgroundColor = Color(0xFF061A32);
const Color cardColor = Color(0xFF0D3155);
const Color blueColor = Color(0xFF0878F9);

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  // API URLs
  static const String postApiUrl =
      'https://meqyas-api.runasp.net/api/Analysis/demo';

  static const String getApiUrl =
      'https://meqyas-api.runasp.net/api/EnergyAlerts/ai-anomalies';

  String selectedFilter = 'All';
  String selectedSort = 'Newest First';

  bool isLoading = true;
  bool isFetching = false;

  String? errorMessage;

  int totalReadings = 0;
  int anomaliesCount = 0;
  int normalCount = 0;
  double anomalyRate = 0;

  List<AlertData> alerts = [];

  @override
  void initState() {
    super.initState();

    // POST first, then GET
    fetchAlerts(runDemo: true);
  }

  // ==========================================
  // POST + GET APIs
  // ==========================================

  Future<void> fetchAlerts({bool runDemo = false}) async {
    if (!mounted || isFetching) return;

    isFetching = true;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // STEP 1: POST - Run AI Analysis
      if (runDemo) {
        debugPrint('Starting POST Analysis...');

        final postResponse = await http.post(
          Uri.parse(postApiUrl),
          headers: const {
            'Accept': '*/*',
          },
        ).timeout(const Duration(seconds: 30));

        debugPrint('POST Status: ${postResponse.statusCode}');
        debugPrint('POST Response: ${postResponse.body}');

        if (postResponse.statusCode < 200 ||
            postResponse.statusCode >= 300) {
          throw Exception(
            'Analysis POST failed: ${postResponse.statusCode}\n'
                '${postResponse.body}',
          );
        }

        final postData =
        jsonDecode(postResponse.body) as Map<String, dynamic>;

        if (postData['succeeded'] != true) {
          throw Exception(
            postData['message']?.toString() ?? 'AI Analysis failed',
          );
        }

        debugPrint('POST Analysis completed successfully');

        // Wait briefly for backend results to become available.
        await Future.delayed(const Duration(seconds: 2));
      }

      // STEP 2: GET - Fetch AI Anomalies
      List<dynamic> results = [];

      const int maxAttempts = 5;

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        debugPrint('Starting GET Alerts - Attempt $attempt');

        // Cache-busting query parameter
        final uri = Uri.parse(getApiUrl).replace(
          queryParameters: {
            'timestamp':
            DateTime.now().millisecondsSinceEpoch.toString(),
          },
        );

        final getResponse = await http.get(
          uri,
          headers: const {
            'Accept': '*/*',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
          },
        ).timeout(const Duration(seconds: 20));

        debugPrint('GET Status: ${getResponse.statusCode}');
        debugPrint('GET Response: ${getResponse.body}');

        if (getResponse.statusCode != 200) {
          throw Exception(
            'GET failed: ${getResponse.statusCode}\n'
                '${getResponse.body}',
          );
        }

        final Map<String, dynamic> responseData =
        jsonDecode(getResponse.body) as Map<String, dynamic>;

        if (responseData['succeeded'] != true) {
          throw Exception(
            responseData['message']?.toString() ??
                'Failed to load alerts',
          );
        }

        results = responseData['data'] as List<dynamic>? ?? [];

        debugPrint('Alerts returned: ${results.length}');

        // Stop retrying if data exists.
        if (results.isNotEmpty) {
          break;
        }

        // Retry only if the API returns an empty list.
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      // STEP 3: Convert API data to AlertData
      final List<AlertData> loadedAlerts = results.map((item) {
        final reading = item as Map<String, dynamic>;

        final String severity =
            reading['severity']?.toString() ?? 'Normal';

        final String status =
            reading['status']?.toString() ?? 'Unknown';

        final bool isAnomaly =
            severity.toLowerCase() != 'normal';

        final double percentage =
            (reading['anomalyPercentage'] as num?)?.toDouble() ?? 0.0;

        final Color alertColor = isAnomaly
            ? const Color(0xFFFF435B)
            : const Color(0xFF16D9A0);

        return AlertData(
          id: reading['id']?.toString() ?? '',
          title: reading['title']?.toString() ?? 'Energy Alert',
          description: reading['description']?.toString() ??
              'No additional information available.',
          severity: severity,
          deviation: '${percentage.toStringAsFixed(2)}%',
          status: status,
          prediction: severity,
          date: reading['detectedAtUtc']?.toString() ?? '',
          isAnomaly: isAnomaly,
          color: alertColor,
          icon: isAnomaly
              ? Icons.warning_rounded
              : Icons.check_circle_rounded,
        );
      }).toList();

      if (!mounted) return;

      // STEP 4: Calculate statistics
      final int loadedAnomalies =
          loadedAlerts.where((alert) => alert.isAnomaly).length;

      final int loadedNormal =
          loadedAlerts.length - loadedAnomalies;

      final double loadedAnomalyRate = loadedAlerts.isEmpty
          ? 0.0
          : (loadedAnomalies / loadedAlerts.length) * 100;

      setState(() {
        alerts = loadedAlerts;

        totalReadings = loadedAlerts.length;
        anomaliesCount = loadedAnomalies;
        normalCount = loadedNormal;
        anomalyRate = loadedAnomalyRate;

        isLoading = false;
      });

      debugPrint('GET completed successfully');
      debugPrint('Total Alerts: ${loadedAlerts.length}');
      debugPrint('Anomalies: $loadedAnomalies');
      debugPrint('Normal: $loadedNormal');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load alerts.\n$e';
      });

      debugPrint('Alerts API Error: $e');
    } finally {
      isFetching = false;
    }
  }

  // ==========================================
  // Alert Statistics
  // ==========================================

  int get activeAlertsCount => alerts
      .where((alert) => alert.status.toLowerCase() == 'active')
      .length;

  int get resolvedAlertsCount => alerts
      .where((alert) => alert.status.toLowerCase() == 'resolved')
      .length;

  // ==========================================
  // Filtering and Sorting
  // ==========================================

  List<AlertData> get filteredAlerts {
    List<AlertData> result;

    switch (selectedFilter) {
      case 'Active':
        result = alerts
            .where((alert) =>
        alert.status.toLowerCase() == 'active')
            .toList();
        break;

      case 'Resolved':
        result = alerts
            .where((alert) =>
        alert.status.toLowerCase() == 'resolved')
            .toList();
        break;

      default:
        result = List<AlertData>.from(alerts);
    }

    result.sort((a, b) {
      final dateA = DateTime.tryParse(a.date);
      final dateB = DateTime.tryParse(b.date);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return selectedSort == 'Newest First'
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    return result;
  }

  void changeFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          // Refresh calls GET only
          onRefresh: () => fetchAlerts(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 10, 13, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.maybePop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const Text(
                            'Alerts',
                            style: TextStyle(
                              color: Color(0xFFF4F7FF),
                              fontSize: 24,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Stay informed about unusual energy patterns\n'
                            'detected by AI.',
                        style: TextStyle(
                          color: Color(0xFFA9BEDD),
                          fontSize: 16,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 21),

                      // Summary Cards
                      Row(
                        children: [
                          Expanded(
                            child: AlertSummaryCard(
                              title: 'Active Alerts',
                              count: activeAlertsCount,
                              icon: Icons.notifications_none_rounded,
                              accent: const Color(0xFFFF315B),
                              fill: const Color(0xFF251C38),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: AlertSummaryCard(
                              title: 'Total Alerts',
                              count: alerts.length,
                              icon: Icons.format_list_bulleted_rounded,
                              accent: const Color(0xFF9BC8F5),
                              fill: const Color(0xFF062746),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: AlertSummaryCard(
                              title: 'Resolved Alerts',
                              count: resolvedAlertsCount,
                              icon: Icons.check_circle_outline_rounded,
                              accent: const Color(0xFF25E5C1),
                              fill: const Color(0xFF00343D),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Filters and Sort
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF032440),
                                border: Border.all(
                                  color: const Color(0xFF075078),
                                ),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AlertFilterButton(
                                      label: 'All',
                                      count: alerts.length,
                                      selected: selectedFilter == 'All',
                                      badgeColor: const Color(0xFF245987),
                                      onTap: () => changeFilter('All'),
                                    ),
                                  ),

                                  Expanded(
                                    child: AlertFilterButton(
                                      label: 'Active',
                                      count: activeAlertsCount,
                                      selected: selectedFilter == 'Active',
                                      badgeColor: const Color(0xFFE92E54),
                                      onTap: () => changeFilter('Active'),
                                    ),
                                  ),

                                  Expanded(
                                    child: AlertFilterButton(
                                      label: 'Resolved',
                                      count: resolvedAlertsCount,
                                      selected: selectedFilter == 'Resolved',
                                      badgeColor: const Color(0xFF087A78),
                                      onTap: () => changeFilter('Resolved'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF032440),
                              border: Border.all(
                                color: const Color(0xFF075078),
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedSort,
                                dropdownColor: const Color(0xFF082B49),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFFA9BEDD),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Newest First',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          size: 17,
                                          color: Color(0xFFA9BEDD),
                                        ),
                                        SizedBox(width: 6),
                                        Text('Newest First'),
                                      ],
                                    ),
                                  ),

                                  DropdownMenuItem(
                                    value: 'Oldest First',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.history_rounded,
                                          size: 17,
                                          color: Color(0xFFA9BEDD),
                                        ),
                                        SizedBox(width: 6),
                                        Text('Oldest First'),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedSort = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Alert History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Review and manage your energy alerts.',
                        style: TextStyle(
                          color: Color(0xFF9EB4CC),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Loading
              if (isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF31B8FF),
                    ),
                  ),
                )

              // Error
              else if (errorMessage != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            color: Color(0xFFFF435B),
                            size: 40,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 12),

                          ElevatedButton(
                            // Retry GET only
                            onPressed: () => fetchAlerts(),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              // Empty
              else if (filteredAlerts.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )

                // Alert List
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final alert = filteredAlerts[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: AlertCard(
                              alert: alert,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: cardColor,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(22),
                                    ),
                                  ),
                                  builder: (_) {
                                    return AlertDetailsSheet(
                                      alert: alert,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        childCount: filteredAlerts.length,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ALERT DATA MODEL
// ==========================================

class AlertData {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String deviation;
  final String status;
  final String prediction;
  final String date;
  final bool isAnomaly;
  final Color color;
  final IconData icon;

  const AlertData({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.deviation,
    required this.status,
    required this.prediction,
    required this.date,
    required this.isAnomaly,
    required this.color,
    required this.icon,
  });
}

// ==========================================
// SUMMARY CARD
// ==========================================

class AlertSummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color accent;
  final Color fill;

  const AlertSummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.accent,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.75),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accent,
              size: 19,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFE1EAF8),
                    fontSize: 9,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$count',
                  style: TextStyle(
                    color: accent,
                    fontSize: 22,
                    height: 0.95,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// FILTER BUTTON
// ==========================================

class AlertFilterButton extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Color badgeColor;
  final VoidCallback onTap;

  const AlertFilterButton({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? const Color(0xFF087CFF)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 38,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 7),

                Container(
                  constraints: const BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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

// ==========================================
// ALERT CARD
// ==========================================

class AlertCard extends StatelessWidget {
  final AlertData alert;
  final VoidCallback onTap;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0E4778),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: alert.color,
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    alert.icon,
                    color: alert.color,
                    size: 22,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      alert.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFB6C9DD),
                    size: 19,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                alert.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFD1E0EF),
                  fontSize: 10,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 9),

              Wrap(
                spacing: 6,
                runSpacing: 5,
                children: [
                  StatusBadge(
                    text: alert.severity,
                    color: alert.color,
                  ),

                  StatusBadge(
                    text: alert.status,
                    color: alert.isAnomaly
                        ? const Color(0xFFFF435B)
                        : const Color(0xFF16D9A0),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    color: Color(0xFFFFAD25),
                    size: 14,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    alert.deviation,
                    style: TextStyle(
                      color: alert.color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Flexible(
                    child: Text(
                      alert.prediction,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Color(0xFFD1E0EF),
                        fontSize: 9,
                      ),
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

// ==========================================
// STATUS BADGE
// ==========================================

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: color.withValues(alpha: 0.65),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ==========================================
// ALERT DETAILS BOTTOM SHEET
// ==========================================

class AlertDetailsSheet extends StatelessWidget {
  final AlertData alert;

  const AlertDetailsSheet({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    alert.icon,
                    color: alert.color,
                    size: 28,
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Alert Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                alert.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                alert.description,
                style: const TextStyle(
                  color: Color(0xFFD1E0EF),
                  fontSize: 13,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 18),

              DetailRow(
                label: 'Reading ID',
                value: alert.id,
              ),

              DetailRow(
                label: 'Prediction',
                value: alert.prediction,
              ),

              DetailRow(
                label: 'Severity',
                value: alert.severity,
                color: alert.color,
              ),

              DetailRow(
                label: 'Anomaly Percentage',
                value: alert.deviation,
              ),

              DetailRow(
                label: 'Status',
                value: alert.status,
              ),

              DetailRow(
                label: 'Analysis Completed',
                value: alert.date,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// DETAIL ROW
// ==========================================

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9EB4CC),
                fontSize: 12,
              ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
