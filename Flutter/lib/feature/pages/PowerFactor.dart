import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meqyas/Api/PowerModel.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/feature/pages/AlertsPage.dart';


// ───────── Colors ─────────
const _panelColor = Color(0xD90C2748);
const _borderColor = Color(0x14FFFFFF);
const _blue = Color(0xFF0788FF);
const _cyan = Color(0xFF4FC3F7);
const _red = Color(0xFFFF5C5C);
const _green = Color(0xFF2ED47A);
const _orange = Color(0xFFFFA726);
const _purple = Color(0xFF9B6BFF);
const _muted = Color(0xFFB4C9DD);
const _teal = Color(0xFF14C8C0);
const _sky = Color(0xFF3AA0FF);

// ⚠️ بيانات تجريبية ثابتة (مش موجودة في الـ API)
// استبدلها بالداتا الحقيقية لما الـ endpoint يتوفر
const _demoActualLoss = '268.2K';
const _demoActualLossChange = 12.3;
const _demoActualLossTrend = <double>[3, 4, 3.5, 5, 4.5, 6, 5.5, 8];
const _demoPotentialLoss = '411.5K';
const _demoPotentialLossChange = 18.7;
const _demoPotentialLossTrend = <double>[4, 3.5, 4.5, 4, 6, 5, 7, 9];
const _demoSystemStatus = 'Under Capacity';
const _demoSystemNote = 'Note: Current operating';

Color _levelColor(RiskLevel l) {
  switch (l) {
    case RiskLevel.high:
      return _red;
    case RiskLevel.medium:
      return _orange;
    case RiskLevel.low:
      return _green;
  }
}

String _levelText(RiskLevel l) {
  switch (l) {
    case RiskLevel.high:
      return 'High';
    case RiskLevel.medium:
      return 'Medium';
    case RiskLevel.low:
      return 'Low';
  }
}

class PowerFactorScreen extends StatefulWidget {
  final PowerFactorData data;

  const PowerFactorScreen({super.key, required this.data});


  @override
  State<PowerFactorScreen> createState() => _PowerFactorScreenState();
}

class _PowerFactorScreenState extends State<PowerFactorScreen> {
  bool _showAll = false;
  String _costType = 'Actual Cost';
  final List<List<double>> _actualCost = _genDemo(7, 1.0);
  final List<List<double>> _potentialCost = _genDemo(21, 1.3);


  PowerFactorData get d => widget.data;

  @override
  Widget build(BuildContext context) {
    final latest = d.results.isNotEmpty ? d.results.first : null;

    return Scaffold(
      backgroundColor: Appcolor.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/photo_2026-10-17_13-24-57.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 18),
                const Text(
                  'Power Factor Intelligence',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Predictive monitoring of low power factor risk over the '
                      'next 3 hours.',
                  style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                _statsRow(),
                const SizedBox(height: 14),
                _trendPanel(),
                const SizedBox(height: 14),
                if (latest != null) _currentAndRisk(latest),
                const SizedBox(height: 14),
                _lossTiles(),
                const SizedBox(height: 14),
                _contributionPanel(),
                const SizedBox(height: 14),
                _recentReadings(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _header() {
    return Row(
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
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/MEQYAS_logo_transparent 1.png',
              height: 36,
              width: 135,
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
      ],
    );
  }

  // ───────── Top 4 stats ─────────
  Widget _statsRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.bar_chart_rounded,
              color: _cyan,
              title: 'Total Readings',
              value: '${d.totalReadings}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatTile(
              icon: Icons.warning_amber_rounded,
              color: _red,
              title: 'Low PF Risk',
              value: '${d.lowPfRiskCount}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatTile(
              icon: Icons.check_circle_outline,
              color: _green,
              title: 'Normal Readings',
              value: '${d.normalCount}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatTile(
              icon: Icons.percent_rounded,
              color: _purple,
              title: 'Risk Rate',
              value: '${d.riskRatePct.toStringAsFixed(0)}%',
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Trend chart ─────────
  Widget _trendPanel() {
    // Average every 5 readings to make the trend easier to read.
    // The original readings and the rest of the screen remain unchanged.
    const readingsPerGroup = 5;

    final pfSpots = <FlSpot>[];
    final riskSpots = <FlSpot>[];
    final groupLabels = <String>[];

    for (var start = 0; start < d.results.length; start += readingsPerGroup) {
      final end = math.min(start + readingsPerGroup, d.results.length);
      final count = end - start;

      var pfSum = 0.0;
      var riskSum = 0.0;

      for (var i = start; i < end; i++) {
        pfSum += d.results[i].actualPowerFactor;
        riskSum += d.results[i].riskProbability;
      }

      final groupIndex = pfSpots.length;
      pfSpots.add(FlSpot(groupIndex.toDouble(), pfSum / count));
      riskSpots.add(FlSpot(groupIndex.toDouble(), riskSum / count));

      // Reading numbers are shown so the user can identify each averaged group.
      groupLabels.add('${start + 1}-$end');
    }

    final lastX = math.max(0, pfSpots.length - 1).toDouble();

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Power Factor Trend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Avg. every $readingsPerGroup readings',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: const [
              _LegendDot(color: _cyan, text: 'Power Factor Average'),
              _LegendDot(color: _purple, text: 'Risk Probability Average'),
              _LegendDot(color: _orange, text: 'Target 0.90'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 205,
            child: d.results.isEmpty
                ? const Center(
              child: Text(
                'No data',
                style: TextStyle(color: _muted),
              ),
            )
                : LineChart(
              LineChartData(
                minY: 0,
                maxY: 1,
                minX: 0,
                maxX: lastX,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 0.2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: groupLabels.length > 1,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= groupLabels.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            groupLabels[index],
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 9,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 0.2,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0.9,
                      color: _orange,
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: riskSpots,
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: _purple,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _purple.withValues(alpha: 0.08),
                    ),
                  ),
                  LineChartBarData(
                    spots: pfSpots,
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: _cyan,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _cyan.withValues(alpha: 0.06),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Each point represents the average of its reading group.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Current PF + Risk gauge ─────────
  Widget _currentAndRisk(PowerFactorResult r) {
    final color = _levelColor(r.level);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: _Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Power Factor',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        r.actualPowerFactor.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.show_chart, color: _red, size: 26),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Target Threshold',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '0.90',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: _Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Risk Probability (Next 3 Hours)',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Gauge(
                        percent: r.riskPercentage,
                        color: color,
                        label: '${_levelText(r.level)} Risk',
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _miniInfo('Forecast Horizon', 'Next 3 Hours'),
                            const SizedBox(height: 8),
                            _miniInfo(
                              'Threshold',
                              r.thresholdUsed.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfo(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: _muted, fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Loss tiles + System status (بيانات تجريبية) ─────────
  Widget _lossTiles() {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _LossTile(
              icon: Icons.center_focus_strong_outlined,
              title: 'Actual Loss (EGP)',
              value: _demoActualLoss,
              change: _demoActualLossChange,
              color: Color(0xFFFF5C8A),
              trend: _demoActualLossTrend,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _LossTile(
              icon: Icons.bolt,
              title: 'Potential Loss (EGP)',
              value: _demoPotentialLoss,
              change: _demoPotentialLossChange,
              color: _orange,
              trend: _demoPotentialLossTrend,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _StatusTile(
              title: 'System Status',
              value: _demoSystemStatus,
              note: _demoSystemNote,
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Main Point(s) Contribution (بيانات تجريبية) ─────────
  Widget _contributionPanel() {
    final data = _costType == 'Actual Cost' ? _actualCost : _potentialCost;
    final maxTotal = data
        .map((e) => e.fold<double>(0, (s, v) => s + v))
        .reduce((a, b) => a > b ? a : b);
    final maxY = ((maxTotal / 50000).ceil() * 50000).toDouble();
    const colors = [_teal, _sky, _orange, _purple];

    final groups = <BarChartGroupData>[];
    for (var i = 0; i < data.length; i++) {
      final seg = data[i];
      var start = 0.0;
      final stacks = <BarChartRodStackItem>[];
      for (var s = 0; s < seg.length; s++) {
        stacks.add(BarChartRodStackItem(start, start + seg[s], colors[s]));
        start += seg[s];
      }
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: start,
              width: 6,
              borderRadius: BorderRadius.zero,
              rodStackItems: stacks,
            ),
          ],
        ),
      );
    }

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Main Point(s) Contribution',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _blue.withValues(alpha: 0.7)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _costType,
                  dropdownColor: const Color(0xFF0C2748),
                  isDense: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: const [
                    DropdownMenuItem(
                      value: 'Actual Cost',
                      child: Text('Actual Cost'),
                    ),
                    DropdownMenuItem(
                      value: 'Potential Cost',
                      child: Text('Potential Cost'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _costType = v);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY,
                alignment: BarChartAlignment.spaceBetween,
                barGroups: groups,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50000,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.white.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    axisNameSize: 16,
                    axisNameWidget: const Text(
                      'EGP',
                      style: TextStyle(color: _muted, fontSize: 9),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 50000,
                      getTitlesWidget: (v, meta) => Text(
                        v == 0 ? '0' : '${(v / 1000).toInt()}K',
                        style: const TextStyle(color: _muted, fontSize: 9),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (v, meta) {
                        final day = v.toInt() + 1;
                        if (day == 1 || day % 5 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Oct ${day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 9,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _LegendDot(color: _teal, text: 'Main Point 1'),
              _LegendDot(color: _sky, text: 'Main Point 2'),
              _LegendDot(color: _orange, text: 'Main Point 3'),
              _LegendDot(color: _purple, text: 'Main Point 4'),
            ],
          ),
        ],
      ),
    );
  }

  // بيانات تجريبية للجراف (استبدلها بالداتا الحقيقية لما تتوفر)
  static List<List<double>> _genDemo(int seed, double scale) {
    final r = math.Random(seed);
    return List.generate(
      30,
          (_) => List.generate(
        4,
            (_) => (8000 + r.nextInt(22000)).toDouble() * scale,
      ),
    );
  }


  Widget _recentReadings() {
    final rows = _showAll ? d.results : d.results.take(5).toList();

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent Readings Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (d.results.length > 5)
                GestureDetector(
                  onTap: () => setState(() => _showAll = !_showAll),
                  child: Text(
                    _showAll ? 'Show less' : 'View all',
                    style: const TextStyle(
                      color: _cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _tableHeader(),
          const Divider(color: Color(0x1FFFFFFF), height: 14),
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No readings', style: TextStyle(color: _muted)),
            ),
          for (var i = 0; i < rows.length; i++) _row(rows[i], i),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    const s = TextStyle(color: _muted, fontSize: 10);
    return const Row(
      children: [
        SizedBox(width: 22, child: Text('ID', style: s)),
        Expanded(flex: 2, child: Text('Current PF', style: s)),
        Expanded(flex: 2, child: Text('Risk Prob.', style: s)),
        Expanded(flex: 3, child: Text('Prediction', style: s)),
        Expanded(flex: 3, child: Text('Status', style: s)),
      ],
    );
  }

  Widget _row(PowerFactorResult r, int index) {
    final level = r.level;
    final color = _levelColor(level);

    return InkWell(
      onTap: () => _showDetails(r, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                r.actualPowerFactor.toStringAsFixed(3),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${r.riskPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _Chip(
                  text: r.isLowPfRisk ? 'Low PF Risk' : 'Normal',
                  color: r.isLowPfRisk ? _red : _green,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _Chip(text: _levelText(level), color: color),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: _muted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(PowerFactorResult r, int index) {
    final color = _levelColor(r.level);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C2748),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Reading #${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _Chip(text: r.prediction, color: color),
              ],
            ),
            const SizedBox(height: 14),
            _detailLine('Actual Power Factor',
                r.actualPowerFactor.toStringAsFixed(3)),
            _detailLine('Q/P Ratio', r.computedQpRatio.toStringAsFixed(4)),
            _detailLine('Risk Probability',
                '${r.riskPercentage.toStringAsFixed(2)}%'),
            _detailLine(
                'Threshold Used', r.thresholdUsed.toStringAsFixed(2)),
            const SizedBox(height: 12),
            Text(
              r.message,
              style: const TextStyle(
                color: _muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: const TextStyle(color: _muted, fontSize: 13)),
          ),
          Text(
            v,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════ Reusable small widgets ═════════════════

class _Panel extends StatelessWidget {
  final Widget child;
  const _Panel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: child,
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _StatTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 26,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted, fontSize: 10, height: 1.25),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  const _Sparkline({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      width: 38,
      height: 22,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i]),
              ],
              isCurved: true,
              color: color,
              barWidth: 1.6,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LossTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final double change;
  final Color color;
  final List<double> trend;

  const _LossTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 15),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: color, size: 11),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  '$change%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _Sparkline(values: trend, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final String title;
  final String value;
  final String note;

  const _StatusTile({
    required this.title,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _cyan.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_tree_outlined,
                  color: _cyan,
                  size: 15,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            maxLines: 2,
            style: const TextStyle(color: _muted, fontSize: 9, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _Gauge extends StatelessWidget {
  final double percent;
  final Color color;
  final String label;

  const _Gauge({
    required this.percent,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              strokeWidth: 9,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percent.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: TextStyle(color: color, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: _muted, fontSize: 10)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      ),
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