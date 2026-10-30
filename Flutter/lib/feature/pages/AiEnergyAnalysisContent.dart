
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meqyas/feature/pages/AnalysisResultsScreen.dart';


class AiEnergyAnalysisContent extends StatefulWidget {
  const AiEnergyAnalysisContent({super.key});

  @override
  State<AiEnergyAnalysisContent> createState() =>
      _AiEnergyAnalysisContentState();
}

class _AiEnergyAnalysisContentState
    extends State<AiEnergyAnalysisContent> {
  static final Uri _apiUrl = Uri.parse(
    'https://meqyas-api.runasp.net/api/Analysis/demo',
  );

  int anomaliesDetected = 0;
  int totalReadings = 0;
  int normalReadings = 0;

  double anomalyRate = 0;
  double averageAnomalyScore = 0;

  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> analysisResults = [];

  Future<void> getAnalysisData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http
          .post(
        _apiUrl,
        headers: const {'Accept': '*/*'},
        body: '',
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid API response.');
      }

      final dynamic payload = decoded['data'] ?? decoded;

      if (payload is! Map<String, dynamic>) {
        throw const FormatException('Invalid analysis data.');
      }

      final rawResults = payload['results'];

      final newResults = rawResults is List
          ? rawResults
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
          : <Map<String, dynamic>>[];

      int? readInt(dynamic value) {
        if (value is num) return value.toInt();
        if (value is String) return int.tryParse(value);
        return null;
      }

      double? readDouble(dynamic value) {
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value);
        return null;
      }

      final calculatedAnomalies = newResults.where((item) {
        return item['isAnomaly'] == true ||
            item['prediction']?.toString().toLowerCase() == 'anomaly';
      }).length;

      final newTotal =
          readInt(payload['totalReadings']) ?? newResults.length;

      final newAnomalies =
          readInt(payload['anomaliesCount']) ??
              readInt(payload['anomaliesDetected']) ??
              calculatedAnomalies;

      final newNormal =
          readInt(payload['normalCount']) ??
              readInt(payload['normalReadings']) ??
              (newTotal - newAnomalies).clamp(0, newTotal);

      final newAnomalyRate =
          readDouble(payload['anomalyRatePct']) ??
              readDouble(payload['anomalyRate']) ??
              (newTotal > 0 ? newAnomalies / newTotal * 100 : 0.0);

      final newAverageScore =
          readDouble(payload['averageAnomalyPercentage']) ??
              readDouble(payload['averageAnomalyScore']) ??
              0.0;

      if (!mounted) return;

      setState(() {
        analysisResults = newResults;
        totalReadings = newTotal;
        anomaliesDetected = newAnomalies;
        normalReadings = newNormal;
        anomalyRate = newAnomalyRate;
        averageAnomalyScore = newAverageScore;
      });
    } catch (e) {
      debugPrint('Error loading analysis: $e');

      if (!mounted) return;

      setState(() {
        errorMessage =
        'Could not load analysis results. Please try again.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to load analysis. Check your connection and try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAnalysisData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062747),
      appBar: AppBar(
        backgroundColor: const Color(0xFF062747),
        foregroundColor: Colors.white,
        title: const Text('AI Energy Analysis'),

      ),
      body: isLoading && totalReadings == 0
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00D6F5),
        ),
      )
          : RefreshIndicator(
        color: const Color(0xFF00D6F5),
        onRefresh: getAnalysisData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analyze industrial readings and detect '
                    'abnormal operating patterns using AI.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF073C52),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'DEMO DATASET',
                  style: TextStyle(
                    color: Color(0xFF00D6F5),
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Analysis Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
                children: [
                  _buildCard(
                    'Anomalies Detected',
                    '$anomaliesDetected',
                    Icons.warning_amber,
                    const Color(0xFFFF426A),
                  ),
                  _buildCard(
                    'Total Readings',
                    '$totalReadings',
                    Icons.description_outlined,
                    const Color(0xFF00D6F5),
                  ),
                  _buildCard(
                    'Anomaly Rate',
                    '${anomalyRate.toStringAsFixed(1)}%',
                    Icons.analytics_outlined,
                    const Color(0xFFFFC04D),
                  ),
                  _buildCard(
                    'Normal Readings',
                    '$normalReadings',
                    Icons.verified_outlined,
                    const Color(0xFF00E6A0),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Analysis Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF126DB7),
                      Color(0xFF08447F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Readings Distribution',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: totalReadings == 0
                                    ? 0
                                    : (anomaliesDetected /
                                    totalReadings)
                                    .clamp(0.0, 1.0),
                                strokeWidth: 10,
                                backgroundColor:
                                const Color(0xFF008FFF),
                                valueColor:
                                const AlwaysStoppedAnimation(
                                  Color(0xFFFF426A),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$totalReadings',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '🔴 Anomalies: $anomaliesDetected '
                          '(${totalReadings == 0 ? '0.0' : (anomaliesDetected / totalReadings * 100).toStringAsFixed(1)}%)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🔵 Normal: $normalReadings '
                          '(${totalReadings == 0 ? '0.0' : (normalReadings / totalReadings * 100).toStringAsFixed(1)}%)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProgress(
                      'Anomaly Rate',
                      anomalyRate,
                      '${anomalyRate.toStringAsFixed(1)}%',
                      const Color(0xFFFF426A),
                    ),
                    const SizedBox(height: 16),
                    _buildProgress(
                      'Average Anomaly Score',
                      averageAnomalyScore,
                      '${averageAnomalyScore.toStringAsFixed(1)}%',
                      const Color(0xFF00D6F5),
                    ),
                  ],
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFFFF8A8A),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed:
                  isLoading ? null : getAnalysisData,
                  child: const Text('Try Again'),
                ),
              ],
              const SizedBox(height: 20),

              // Navigate to Analysis Results screen.
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: analysisResults.isEmpty
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AnalysisResultsScreen(
                              results: analysisResults,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF087BFF),
                    disabledBackgroundColor:
                    const Color(0xFF365675),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Analysis Results',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 70,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF126DB7),
            Color(0xFF08447F),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(
      String title,
      double value,
      String label,
      Color color,
      ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (value / 100).clamp(0.0, 1.0),
          minHeight: 5,
          backgroundColor: const Color(0xFF063665),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}
