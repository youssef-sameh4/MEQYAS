import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/Widgets/Cards.dart';
import 'package:meqyas/Widgets/buildHeader.dart';
import 'package:meqyas/feature/pages/AlertsPage.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04172D),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
SizedBox(height: 20,),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Energy Analytics',  style: TextStyle(
      color: Colors.white,
      fontSize: 19,
      fontWeight: FontWeight.bold,
    ),),


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
),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(3, 8, 3, 18),
                    child: Column(
                      children: [
                        _buildConsumptionCard(),
                        const SizedBox(height: 10),
                        // STATISTICS
                        Row(
                          children: [
                            Expanded(
                              child: statCard(
                                CircleAvatarcolor: Appcolor.blueColor,

                                title: 'Total Consumption',
                                value: '1,240 kWh',
                                showLastRow: false,

                                Heigh: 80,
                                color: Appcolor.black,
                                iconimage: 'assets/Vector (13).png',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: statCard(
                                color2: Colors.red,

                                CircleAvatarcolor: Appcolor.darkdarkblue,

                                title: 'Total Cost',
                                value: 'EGP 12,400',

                                Heigh: 80,
                                showLastRow: false,
                                color: Appcolor.pink,
                                iconimage: 'assets/Group (2).png',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: statCard(
                                CircleAvatarcolor: Appcolor.lightgreen,
                                Heigh: 80,
                                title: 'Production',
                                value: '850 Units',
                                showLastRow: false,
                                color: Appcolor.green,
                                iconimage: 'assets/Group (1).png',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: statCard(
                                CircleAvatarcolor: Appcolor.lightgreen,
                                title: 'Total Energy',
                                value: '1.6 kWh',
                                showLastRow: false,

                                Heigh: 80,
                                color: Appcolor.leafcolor,
                                iconimage: 'assets/Vector (12).png',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        _buildProductionChart(),
                      ],
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

  Widget _buildConsumptionCard() {
    final values = selectedPeriod == 'Day'
        ? [34.0, 56.0, 42.0, 68.0, 48.0, 74.0, 58.0]
        : selectedPeriod == 'Month'
        ? [58.0, 39.0, 67.0, 47.0, 75.0, 54.0, 80.0]
        : [42.0, 65.0, 48.0, 76.0, 56.0, 72.0, 50.0];
    const labels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Container(
      width: double.infinity,
      height: 172.2,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0756B8), Color(0xFF103866), Color(0xFF0B2B50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.16),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Consumption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,

                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Container(
                    width: 104,
                    height: 20,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.13),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: ['Day', 'Week', 'Month'].map((period) {
                        final active = selectedPeriod == period;
                        return GestureDetector(
                          onTap: () => setState(() => selectedPeriod = period),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white.withOpacity(.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              period,
                              style: TextStyle(
                                color: active ? Colors.white : Colors.white54,
                                fontSize: 5.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_upward, color: Appcolor.lightgreen),
                      const Text(
                        '12% ',
                        style: TextStyle(
                          color: Appcolor.lightgreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          const SizedBox(height: 7),
          SizedBox(
            height: 86,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(values.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: values[index],
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: 9,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF42A5FF,
                                      ).withOpacity(.78),
                                      borderRadius: BorderRadius.circular(1.5),
                                    ),
                                  ),
                                  if (index == 1 || index == 4 || index == 6)
                                    Positioned(
                                      top: 0,
                                      child: Container(
                                        width: 9,
                                        height: values[index] * .46,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFC857),
                                          borderRadius: BorderRadius.circular(
                                            1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[index],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
        color: Appcolor.cardColor.withOpacity(.96),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.white.withOpacity(.055)),
      ),
      child: Row(
        children: [
          Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: color.withOpacity(.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 11),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 7.5),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildProductionChart() {
    const actual = [1.0, 1.5, 2.5, 3.0, 2.6, 3.5, 3.2, 4.0, 3.7, 4.5];
    const expected = [2.8, 2.8, 2.8, 2.8, 2.8, 2.8, 2.8, 2.8, 2.8, 2.8];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      decoration: BoxDecoration(
        color: Appcolor.cardColor.withOpacity(.97),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Production vs Energy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.remove, color: Color(0xFF13D99A), size: 10),
              SizedBox(width: 2),
              Text(
                'Expected',
                style: TextStyle(color: Colors.white70, fontSize: 6),
              ),
              SizedBox(width: 8),
              Icon(Icons.show_chart, color: Color(0xFF42A5FF), size: 10),
              SizedBox(width: 2),
              Text(
                'Actual',
                style: TextStyle(color: Colors.white70, fontSize: 6),
              ),
            ],
          ),
          const SizedBox(height: 3),
          SizedBox(
            height: 105,
            width: double.infinity,
            child: CustomPaint(
              painter: _ProductionChartPainter(
                actual: actual,
                expected: expected,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 3, 2, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(5, (i) {
                          return Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${5 - i}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 6,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: days
                          .map(
                            (day) => Text(
                              day,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 6,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductionChartPainter extends CustomPainter {
  final List<double> actual;
  final List<double> expected;

  _ProductionChartPainter({required this.actual, required this.expected});

  @override
  void paint(Canvas canvas, Size size) {
    const left = 10.0;
    const top = 4.0;
    const bottom = 16.0;
    const right = 2.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(.13)
      ..strokeWidth = .6;
    for (int i = 0; i <= 5; i++) {
      final y = top + chartHeight * i / 5;
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
    }
    for (int i = 0; i < 7; i++) {
      final x = left + chartWidth * i / 6;
      canvas.drawLine(
        Offset(x, top),
        Offset(x, top + chartHeight),
        gridPaint..color = Colors.white.withOpacity(.07),
      );
    }

    Offset point(int index, double value, int count) {
      return Offset(
        left + chartWidth * index / (count - 1),
        top + chartHeight * (1 - value / 5),
      );
    }

    final fillPath = Path()
      ..moveTo(point(0, actual[0], actual.length).dx, top + chartHeight);
    for (int i = 0; i < actual.length; i++) {
      final p = point(i, actual[i], actual.length);
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(
      point(actual.length - 1, actual.last, actual.length).dx,
      top + chartHeight,
    );
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xAA1749FF), Color(0xCC172EC1)],
        ).createShader(Rect.fromLTWH(left, top, chartWidth, chartHeight)),
    );

    final expectedPath = Path();
    for (int i = 0; i < expected.length; i++) {
      final p = point(i, expected[i], expected.length);
      if (i == 0) {
        expectedPath.moveTo(p.dx, p.dy);
      } else {
        expectedPath.lineTo(p.dx, p.dy);
      }
    }
    final expectedPaint = Paint()
      ..color = const Color(0xFF13D99A)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    _drawDashedPath(canvas, expectedPath, expectedPaint);

    final actualPath = Path();
    for (int i = 0; i < actual.length; i++) {
      final p = point(i, actual[i], actual.length);
      if (i == 0) {
        actualPath.moveTo(p.dx, p.dy);
      } else {
        actualPath.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      actualPath,
      Paint()
        ..color = const Color(0xFF55A8FF)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (int i = 0; i < actual.length; i++) {
      final p = point(i, actual[i], actual.length);
      canvas.drawCircle(p, 1.4, Paint()..color = const Color(0xFFB8DFFF));
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      const dashLength = 4.0;
      const gapLength = 3.0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ProductionChartPainter oldDelegate) {
    return oldDelegate.actual != actual || oldDelegate.expected != expected;
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