
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';

class FinancialImpactScreen extends StatelessWidget {
  const FinancialImpactScreen({super.key});

  static const Color navy = Color(0xFF07182F);
  static const Color card = Color(0xFF10345B);
  static const Color blue = Color(0xFF0878F9);
  static const Color cyan = Color(0xFF21D4F3);
  static const Color green = Color(0xFF13D99A);
  static const Color orange = Color(0xFFFFA34D);

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    14, 8, 14, 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          _iconButton(
                            Icons.arrow_back,
                            onTap: () => Navigator.maybePop(context),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Financial Impact',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _iconButton(
                            Icons.share_outlined,
                            onTap: () => _showMessage(
                              context,
                              'Share Financial Impact',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      // BREADCRUMB
                      const Row(
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: Colors.white54,
                            size: 13,
                          ),
                          Text(
                            'Anomaly Details',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 9,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                            size: 13,
                          ),
                          Text(
                            'Financial Impact',
                            style: TextStyle(
                              color: cyan,
                              fontSize: 9,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'MEQYAS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // TOP METRICS
                      Row(
                        children: [
                          Expanded(
                            child: _metricCard(
                              title: 'Energy Consumption',
                              value: '150,000',
                              unit: 'kWh',
                              description:
                              'Aggregated excess consumption',
                              icon: Icons.bolt,
                              color: cyan,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _metricCard(
                              title: 'Average Tariff',
                              value: 'EGP 3.0',
                              unit: '/ kWh',
                              description:
                              'Estimated energy unit rate',
                              icon: Icons.payments_outlined,
                              color: green,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ESTIMATED COST
                      _panel(
                        child: Row(
                          children: [
                            Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                color: green.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.price_change_outlined,
                                color: green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Cost',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'EGP 450,000',
                                      style: TextStyle(
                                        color: cyan,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Estimated additional energy cost',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // FINANCIAL LOSS CHART
                      _panel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estimated Financial Loss Trend',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Monthly estimated financial loss',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 13),

                            SizedBox(
                              height: 145,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: _FinancialChartPainter(),
                              ),
                            ),

                            const SizedBox(height: 7),

                            const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                _ChartLabel('Mar'),
                                _ChartLabel('Apr'),
                                _ChartLabel('May'),
                                _ChartLabel('Jun'),
                                _ChartLabel('Jul'),
                                _ChartLabel('Aug'),
                              ],
                            ),

                            const SizedBox(height: 10),

                            const Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                _LegendItem(
                                  color: cyan,
                                  label: 'Energy Loss',
                                ),
                                _LegendItem(
                                  color: blue,
                                  label: 'Cost Trend',
                                ),
                                _LegendItem(
                                  color: orange,
                                  label: 'Current Period',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // CALCULATION DETAILS
                      _panel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.calculate_outlined,
                                  color: cyan,
                                  size: 17,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  'Calculation Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 13),

                            _detail(
                              'Extra Energy Consumption',
                              '150,000 kWh',
                            ),

                            const SizedBox(height: 11),

                            const Text(
                              'Excess energy compared with baseline '
                                  'consumption during the selected period.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 13),

                            _detail(
                              'Average Energy Tariff',
                              'EGP 3.0 / kWh',
                            ),

                            const SizedBox(height: 11),

                            const Text(
                              'Estimated average cost per unit of '
                                  'electricity.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 13),

                            const Divider(
                              color: Color(0xFF31516D),
                              height: 1,
                            ),

                            const SizedBox(height: 13),

                            _detail(
                              'Estimated Financial Impact',
                              'EGP 450,000',
                              valueColor: cyan,
                            ),

                            const SizedBox(height: 12),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A2947),
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: cyan.withOpacity(0.2),
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: cyan,
                                        size: 14,
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Estimated Financial Impact',
                                          style: TextStyle(
                                            color: cyan,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    '150,000 kWh × EGP 3.0 / kWh '
                                        '= EGP 450,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Note: This is an estimate based on the '
                                  'selected energy consumption and tariff. '
                                  'Actual financial impact may vary due to '
                                  'operating conditions and tariff changes.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // BOTTOM NAVIGATION
              const _FinancialBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _iconButton(
      IconData icon, {
        required VoidCallback onTap,
      }) {
    return Material(
      color: const Color(0xFF102D50),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  static Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xED10345B),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _metricCard({
    required String title,
    required String value,
    required String unit,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xE810345B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 8,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _detail(
      String title,
      String value, {
        Color valueColor = Colors.white,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static void _showMessage(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// --------------------------------------------------
// FINANCIAL CHART
// --------------------------------------------------

class _FinancialChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const left = 29.0;
    const top = 9.0;
    const right = 5.0;
    const bottom = 8.0;

    final width = size.width - left - right;
    final height = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = const Color(0xFF31516D)
      ..strokeWidth = 0.6;

    final textStyle = const TextStyle(
      color: Colors.white54,
      fontSize: 7,
    );

    for (int i = 0; i < 5; i++) {
      final y = top + height * i / 4;

      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );

      final label = TextPainter(
        text: TextSpan(
          text: '${100 - i * 25}k',
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      label.paint(canvas, Offset(0, y - 4));
    }

    const values = [25.0, 45.0, 85.0, 55.0, 95.0, 62.0];

    final barWidth = width / 13;
    final gap = (width - barWidth * values.length) / 5;

    for (int i = 0; i < values.length; i++) {
      final x = left + i * (barWidth + gap);
      final barHeight = height * values[i] / 100;
      final y = top + height - barHeight;

      final color = i == values.length - 1
          ? const Color(0xFFFFA34D)
          : (i.isEven
          ? const Color(0xFF0878F9)
          : const Color(0xFF21D4F3));

      final paint = Paint()..color = color;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FinancialChartPainter oldDelegate) {
    return false;
  }
}

class _ChartLabel extends StatelessWidget {
  final String label;

  const _ChartLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 8,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// BOTTOM NAVIGATION
// --------------------------------------------------

class _FinancialBottomNavigation extends StatelessWidget {
  const _FinancialBottomNavigation();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.analytics_outlined, 'Analytics'),
      (Icons.notifications_none, 'Alerts'),
      (Icons.auto_awesome, 'AI'),
      (Icons.settings_outlined, 'Settings'),
      (Icons.smart_toy_outlined, 'Simulator'),
    ];

    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Color(0xF20C2748),
        border: Border(
          top: BorderSide(
            color: Color(0xFF24496C),
            width: 0.7,
          ),
        ),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: InkWell(
                onTap: () {
                  // Connect to HomeNavigation if needed.
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.$1,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 7,
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
}
