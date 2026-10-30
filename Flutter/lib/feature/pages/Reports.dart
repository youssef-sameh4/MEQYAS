
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/feature/pages/available_reports_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const Color _white = Color(0xFFF1F6FF);
  static const Color _muted = Color(0xFF9AB6D5);
  static const Color _cyan = Color(0xFF22DDF2);
  static const Color _blue = Color(0xFF087CFF);
  static const Color _panel = Color(0xFF10395F);
  static const Color _border = Color(0xFF1A5484);

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
              _buildHeader(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExecutiveReport(),

                      const SizedBox(height: 15),

                      _buildReportSummary(),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 39,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AvailableReportsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Download Reports',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 90,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 12, 10),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.arrow_back,
                color: _white,
                size: 19,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports',
                style: TextStyle(
                  color: _white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Turn energy data into clear business reports.',
                style: TextStyle(
                  color: _muted,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveReport() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF10375D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _border,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Executive Summary Report',
                  style: TextStyle(
                    color: _white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A526F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    color: _cyan,
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _buildReportPreview(),
              ),

              const SizedBox(width: 10),

              const Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delta Foods Factory',
                      style: TextStyle(
                        color: _white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1 Aug 2024 – 31 Aug 2024',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: _cyan,
                          size: 5,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Executive',
                          style: TextStyle(
                            color: _cyan,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text(
                      'A concise view of performance and opportunities.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          const Text(
            'Sample prototype data',
            style: TextStyle(
              color: Color(0xFF668EB5),
              fontSize: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportPreview() {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Image.asset("assets/Editable document cover.png",height: 188,width: 126,)
        ],

    );
  }

  Widget _buildReportSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF15599A),
            Color(0xFF0A2E53),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _border,
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notes,
                color: _cyan,
                size: 13,
              ),
              SizedBox(width: 5),
              Text(
                'Report Summary',
                style: TextStyle(
                  color: _white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          _summarySection(
            'Energy consumption trend',
            'Consumption increased by 12% compared with the previous period.',
          ),

          _summarySection(
            'Production comparison',
            'Production increased by 3%, below the 12% energy increase.',
          ),

          _summarySection(
            'Energy intensity',
            '1,459 kWh/Ton. The energy increase outpaced production, review efficiency against the baseline.',
          ),

          _summarySection(
            'Active anomalies',
            'Peak-hour consumption and intensity changes are observations requiring review, not confirmed equipment faults.',
          ),

          _summarySection(
            'Key recommendations',
            'Review compressed air, production scheduling, HVAC and lighting.',
          ),

          _summarySection(
            'Estimated financial impact',
            'EGP 450,000 is an illustrative sample estimate, not actual or verified savings.',
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _summarySection(
      String title,
      String description, {
        bool last = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: const TextStyle(
              color: _muted,
              fontSize: 9,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Connect your PDF export service to download reports.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF10395F),
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF24577D)
      ..strokeWidth = 0.6;

    final linePaint = Paint()
      ..color = const Color(0xFF18D5E9)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final y = i * size.height / 2;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width * 0.15, size.height * 0.65)
      ..lineTo(size.width * 0.27, size.height * 0.82)
      ..lineTo(size.width * 0.43, size.height * 0.38)
      ..lineTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height * 0.22)
      ..lineTo(size.width * 0.84, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.12);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
