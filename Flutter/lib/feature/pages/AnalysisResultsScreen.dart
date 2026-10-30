
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnalysisResultsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> results;

  const AnalysisResultsScreen({
    super.key,
    required this.results,
  });

  @override
  State<AnalysisResultsScreen> createState() =>
      _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState
    extends State<AnalysisResultsScreen> {
  static final Uri _apiUrl = Uri.parse(
    'https://meqyas-api.runasp.net/api/Analysis/demo',
  );

  late List<Map<String, dynamic>> _results;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  String _filter = 'All';
  bool _isResetting = false;

  final Set<String> _expandedItems = {};

  static const Color _background = Color(0xFF062747);
  static const Color _panel = Color(0xFF0A3C69);
  static const Color _card = Color(0xFF105B99);
  static const Color _blue = Color(0xFF087BFF);
  static const Color _cyan = Color(0xFF00D6F5);
  static const Color _red = Color(0xFFFF426A);
  static const Color _border = Color(0xFF17466E);

  @override
  void initState() {
    super.initState();
    _results = List<Map<String, dynamic>>.from(widget.results);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isAnomaly(Map<String, dynamic> item) {
    final prediction =
    (item['prediction'] ?? '').toString().toLowerCase();

    return item['isAnomaly'] == true ||
        prediction == 'anomaly' ||
        prediction == 'abnormal';
  }

  double _anomalyPercentage(Map<String, dynamic> item) {
    final value = item['anomalyPercentage'];

    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;

    return 0;
  }

  double _rawScore(Map<String, dynamic> item) {
    final value = item['rawScore'];

    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;

    return 0;
  }

  String _prediction(Map<String, dynamic> item) {
    final value = item['prediction']?.toString();

    if (value != null && value.isNotEmpty) {
      return value[0].toUpperCase() + value.substring(1);
    }

    return _isAnomaly(item) ? 'Anomaly' : 'Normal';
  }

  String _resultId(Map<String, dynamic> item) {
    return (item['id'] ?? 'Unknown').toString();
  }

  String _displayValue(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'Not available';
    }

    return value.toString();
  }

  List<Map<String, dynamic>> get _filteredResults {
    return _results.where((item) {
      final prediction = _prediction(item).toLowerCase();
      final id = _resultId(item).toLowerCase();
      final message =
      (item['message'] ?? '').toString().toLowerCase();

      final matchesSearch =
          id.contains(_searchQuery) ||
              prediction.contains(_searchQuery) ||
              message.contains(_searchQuery);

      final isAnomaly = _isAnomaly(item);

      final matchesFilter = switch (_filter) {
        'Anomaly' => isAnomaly,
        'Normal' => !isAnomaly,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> _resetAnalysis() async {
    if (_isResetting) return;

    setState(() {
      _isResetting = true;
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
          'Request failed: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid API response');
      }

      final payload = decoded['data'] ?? decoded;

      if (payload is! Map<String, dynamic>) {
        throw const FormatException('Invalid analysis data');
      }

      final rawResults = payload['results'];

      if (rawResults is! List) {
        throw const FormatException(
          'The response does not contain a results list',
        );
      }

      final newResults = rawResults
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      if (!mounted) return;

      setState(() {
        _results = newResults;
        _searchQuery = '';
        _searchController.clear();
        _filter = 'All';
        _expandedItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analysis results refreshed successfully.'),
          backgroundColor: Color(0xFF087B65),
        ),
      );
    } catch (e) {
      debugPrint('Reset analysis error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not refresh results. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...['All', 'Anomaly', 'Normal'].map((option) {
                  return RadioListTile<String>(
                    value: option,
                    groupValue: _filter,
                    activeColor: _cyan,
                    title: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _filter = value;
                      });

                      Navigator.pop(sheetContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Analysis Results',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isResetting ? null : _resetAnalysis,
            icon: _isResetting
                ? const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _cyan,
              ),
            )
                : const Icon(Icons.refresh, size: 19),
            label: const Text('Reset'),
            style: TextButton.styleFrom(
              foregroundColor: _cyan,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Analyze industrial readings and detect abnormal '
                    'operating patterns using AI.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.layers,
                  color: _cyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Analysis Results (${results.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF084578),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase().trim();
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search results...',
                        hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 19,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: const Color(0xFF07599A),
                  borderRadius: BorderRadius.circular(9),
                  child: InkWell(
                    onTap: _showFilters,
                    borderRadius: BorderRadius.circular(9),
                    child: const SizedBox(
                      height: 42,
                      width: 42,
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: results.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_off,
                      color: Colors.white54,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No results found',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                          _filter = 'All';
                        });
                      },
                      child: const Text('Clear search and filters'),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return _buildResultCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(
      Map<String, dynamic> item,
      int index,
      ) {
    final anomaly = _isAnomaly(item);
    final color = anomaly ? _red : const Color(0xFF00D6A0);
    final percentage = _anomalyPercentage(item);
    final id = _resultId(item);
    final expanded = _expandedItems.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1269AD),
            Color(0xFF0A3D6B),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _border,
          width: 0.7,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    anomaly
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    color: color,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '#${index + 1}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    _prediction(item),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: anomaly
                        ? const Color(0xFF84284A)
                        : const Color(0xFF087B65),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      if (expanded) {
                        _expandedItems.remove(id);
                      } else {
                        _expandedItems.add(id);
                      }
                    });
                  },
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.chevron_right,
                    color: Colors.white70,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: _border,
            indent: 12,
            endIndent: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _info(
                        'Prediction',
                        _prediction(item),
                      ),
                    ),
                    Expanded(
                      child: _info(
                        'Is Anomaly',
                        anomaly ? 'Yes' : 'No',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: _border),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _info(
                        'Anomaly Score',
                        '${percentage.toStringAsFixed(1)}%',
                      ),
                    ),
                    Expanded(
                      child: _info(
                        'Raw Score',
                        _rawScore(item).toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: _border),
                const SizedBox(height: 12),
                _info(
                  'Energy Reading ID',
                  _displayValue(item['energyReadingId']),
                ),
                const SizedBox(height: 14),
                _info(
                  'AI Message',
                  _displayValue(item['message']),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(
                    width: double.infinity,
                    height: 0,
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: _border),
                        const SizedBox(height: 8),
                        const Text(
                          'Technical Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _info('Result ID', id),
                        const SizedBox(height: 12),
                        _info(
                          'Energy Reading ID',
                          _displayValue(item['energyReadingId']),
                        ),
                        const SizedBox(height: 12),
                        _info(
                          'Raw Score',
                          _rawScore(item).toString(),
                        ),
                      ],
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

  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
