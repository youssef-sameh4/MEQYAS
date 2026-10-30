import 'package:flutter/material.dart';
import 'package:meqyas/feature/pages/Financial%20Impact.dart';

class AnomalyDetailsScreen extends StatelessWidget {
  const AnomalyDetailsScreen({super.key});

  static const Color bg = Color(0xFF06172D);
  static const Color card = Color(0xFF0D2B4D);
  static const Color blue = Color(0xFF0878F9);
  static const Color cyan = Color(0xFF21D4F3);
  static const Color green = Color(0xFF13D99A);
  static const Color orange = Color(0xFFFFA34D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF071A32),
                      Color(0xFF0B2A49),
                      Color(0xFF06172D),
                    ],
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP BAR
                  Row(
                    children: [
                      _iconButton(
                        Icons.arrow_back,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Anomaly Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _iconButton(
                        Icons.share_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share anomaly details'),
                            ),
                          );
                        },
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
                        'Energy Management',
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
                        'Anomaly Details',
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
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  // ANOMALY SUMMARY
                  _panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: orange,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unusual High Consumption',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Compressor System',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Wrap(
                          spacing: 7,
                          runSpacing: 6,
                          children: [
                            _Tag(
                              'High Severity',
                              Color(0xFF8F3039),
                              orange,
                            ),
                            _Tag(
                              'Needs Investigation',
                              Color(0xFF105347),
                              green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),


                  Row(
                    children: [
                      _tab('Overview', true),
                      _tab('Energy Impact', false),
                      _tab('Possible Causes', false),
                    ],
                  ),

                  const SizedBox(height: 13),


                  Row(
                    children: [
                      Expanded(
                        child: _metric(
                          'Actual',
                          '13,000',
                          'kWh',
                          cyan,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _metric(
                          'Baseline',
                          '10,000',
                          'kWh',
                          Colors.white,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _metric(
                          'Deviation',
                          '+30%',
                          'Above baseline',
                          green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  // CONSUMPTION PATTERN
                  _panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Consumption Pattern',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '+30%',
                              style: TextStyle(
                                color: orange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        const Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            _Legend(
                              color: cyan,
                              label: 'Actual',
                            ),
                            _Legend(
                              color: green,
                              label: 'Baseline',
                            ),
                            _Legend(
                              color: orange,
                              label: 'Anomaly',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 145,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _ConsumptionChartPainter(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SmallLabel('08:00'),
                            _SmallLabel('10:00'),
                            _SmallLabel('12:00'),
                            _SmallLabel('14:00'),
                            _SmallLabel('16:00'),
                            _SmallLabel('18:00'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),

                  // KEY FINDINGS
                  _panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Key Findings',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _finding(
                          Icons.info_outline,
                          cyan,
                          'Consumption increased by 30% compared '
                              'with the selected baseline.',
                        ),
                        const SizedBox(height: 10),
                        _finding(
                          Icons.access_time,
                          green,
                          'The observed deviation occurred during '
                              'the selected reporting period.',
                        ),
                        const SizedBox(height: 12),
                        const Divider(
                          color: Color(0xFF294766),
                          height: 1,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Estimated Financial Impact: EGP 450,000',
                          style: TextStyle(
                            color: orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Excessive consumption may increase '
                              'operational costs. Review the equipment '
                              'schedule and operating conditions.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 30,),

                ],
              ),
            ),

            Positioned(
              left: 14,
              right: 14,
              bottom: 80,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinancialImpactScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F9),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color(0xFF0878F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Financial Impact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 21),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            // BOTTOM ACTION - direct child of Stack


            // BOTTOM ACTION



          ],
        ),
      ),
    );
  }

  static Widget _iconButton(
      IconData icon, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 30,
        height: 32,
        child: Icon(
          icon,
          color: Colors.white,
          size: 19,
        ),
      ),
    );
  }

  static Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF28517A).withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _metric(
      String title,
      String value,
      String unit,
      Color valueColor,
      ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF28517A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            unit,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _tab(String title, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? cyan : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? cyan : Colors.white60,
            fontSize: 9,
            fontWeight:
            selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  static Widget _finding(
      IconData icon,
      Color color,
      String text,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Tag(
      this.label,
      this.background,
      this.foreground,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({
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
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String text;

  const _SmallLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 8,
      ),
    );
  }
}

class _ConsumptionChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const left = 22.0;
    const top = 8.0;
    const right = 4.0;
    const bottom = 10.0;

    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = const Color(0xFF31516D)
      ..strokeWidth = 0.6;

    for (int i = 0; i < 5; i++) {
      final y = top + chartHeight * i / 4;

      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );

      final label = TextPainter(
        text: TextSpan(
          text: '${50 - i * 10}',
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 7,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      label.paint(canvas, Offset(0, y - 4));
    }

    final actual = [
      0.45, 0.55, 0.35, 0.30, 0.40,
      0.65, 0.85, 0.72, 0.58, 0.50,
      0.38, 0.32,
    ];

    final baseline = [
      0.42, 0.46, 0.40, 0.37, 0.43,
      0.50, 0.60, 0.58, 0.50, 0.45,
      0.40, 0.38,
    ];

    Offset point(int index, double value) {
      return Offset(
        left + chartWidth * index / (actual.length - 1),
        top + chartHeight * (1 - value),
      );
    }

    void drawLine(
        List<double> values,
        Color color,
        double strokeWidth,
        ) {
      final path = Path();

      for (int i = 0; i < values.length; i++) {
        final p = point(i, values[i]);

        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }

      final paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, paint);
    }

    // Baseline
    drawLine(baseline, const Color(0xFF13D99A), 1.4);

    // Actual consumption
    drawLine(actual, const Color(0xFF21D4F3), 1.6);

    // Highlight anomaly region
    final highlight = Paint()
      ..color = const Color(0xFFFFA34D)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      point(5, actual[5]),
      point(6, actual[6]),
      highlight,
    );
    canvas.drawLine(
      point(6, actual[6]),
      point(7, actual[7]),
      highlight,
    );

    // Actual data points
    final dotPaint = Paint()..color = const Color(0xFF21D4F3);

    for (int i = 0; i < actual.length; i++) {
      canvas.drawCircle(point(i, actual[i]), 1.7, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}