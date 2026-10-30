
import 'package:flutter/material.dart';

class RecommendationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> recommendation;

  const RecommendationDetailsScreen({
    super.key,
    required this.recommendation,
  });

  @override
  State<RecommendationDetailsScreen> createState() =>
      _RecommendationDetailsScreenState();
}

class _RecommendationDetailsScreenState
    extends State<RecommendationDetailsScreen> {
  static const Color cyan = Color(0xFF00DDF5);
  static const Color green = Color(0xFF00E5B0);

  late List<bool> completedSteps;

  Map<String, dynamic> get item => widget.recommendation;

  List<String> get actionSteps =>
      List<String>.from(item['actionSteps'] ?? [
        'Review current operating conditions',
        'Collect relevant measurements',
        'Identify improvement opportunities',
        'Prepare an implementation plan',
      ]);

  @override
  void initState() {
    super.initState();
    completedSteps = List.filled(actionSteps.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final String title = (item['title'] ?? 'Recommendation')
        .toString()
        .replaceAll('\n', ' ');

    final String description =
        item['description'] ?? 'No description available.';

    final String category =
        item['category'] ?? 'General Recommendation';

    final String priority =
        item['priority'] ?? 'Not specified';

    final String saving = item['saving'] ?? 'N/A';

    final String unit = item['unit'] ?? '/year';

    final String impact =
        item['impact'] ?? 'Potential operational improvement';

    final String why = item['why'] ??
        'This recommendation identifies an opportunity to improve '
            'facility performance, reduce operating costs, and improve '
            'overall efficiency.';

    final int completedCount =
        completedSteps.where((value) => value).length;

    return Scaffold(
      backgroundColor: const Color(0xFF061B32),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1516937941344-00b4e0337589'
                  '?auto=format&fit=crop&w=900&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xE8071D35),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Recommendation Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                    children: [
                      // Recommendation information
                      _DetailsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CategoryLabel(text: category),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              description,
                              style: const TextStyle(
                                color: Color(0xFFB5C9DF),
                                fontSize: 10,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 13),
                            const Text(
                              'Estimated Annual Savings',
                              style: TextStyle(
                                color: Color(0xFF9CB8D3),
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$saving$unit',
                              style: const TextStyle(
                                color: green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _Metric(
                                    label: 'Potential Impact',
                                    value: impact,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _Metric(
                                    label: 'Priority',
                                    value: priority,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Why this recommendation?
                      _DetailsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionTitle(
                              icon: Icons.lightbulb_outline,
                              title: 'Why this recommendation?',
                            ),
                            const SizedBox(height: 10),
                            Text(
                              why,
                              style: const TextStyle(
                                color: Color(0xFFB8CBE0),
                                fontSize: 10,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Dynamic action plan
                      _DetailsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionTitle(
                              icon: Icons.checklist_rounded,
                              title: 'Action Plan',
                            ),
                            const SizedBox(height: 10),

                            ...List.generate(actionSteps.length, (index) {
                              return CheckboxListTile(
                                value: completedSteps[index],
                                onChanged: (value) {
                                  setState(() {
                                    completedSteps[index] =
                                        value ?? false;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                controlAffinity:
                                ListTileControlAffinity.leading,
                                activeColor: green,
                                checkColor: const Color(0xFF092D51),
                                side: const BorderSide(
                                  color: Color(0xFF6485A5),
                                ),
                                title: Text(
                                  actionSteps[index],
                                  style: TextStyle(
                                    color: completedSteps[index]
                                        ? green
                                        : const Color(0xFFB8CBE0),
                                    fontSize: 10,
                                    decoration: completedSteps[index]
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: actionSteps.isEmpty
                                    ? 0
                                    : completedCount / actionSteps.length,
                                minHeight: 5,
                                backgroundColor: const Color(0xFF244563),
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$completedCount of ${actionSteps.length} '
                                  'steps completed',
                              style: const TextStyle(
                                color: Color(0xFF8DAAC5),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Savings verification
                      _DetailsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionTitle(
                              icon: Icons.verified_outlined,
                              title: 'Savings Verification',
                            ),
                            const SizedBox(height: 12),
                            _VerificationItem(
                              title: 'Estimated Savings',
                              description:
                              'Expected savings: $saving$unit.',
                            ),
                            const SizedBox(height: 12),
                            const _VerificationItem(
                              title: 'Actual Savings',
                              description:
                              'To be calculated from measurements '
                                  'after implementation.',
                            ),
                            const SizedBox(height: 12),
                            const _VerificationItem(
                              title: 'Verified Savings',
                              description:
                              'To be confirmed after reviewing '
                                  'the measured results.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Implementation plan selected',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF087CF5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Start Implementation',
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

                SizedBox(height: 70,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final Widget child;

  const _DetailsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF15538A),
            Color(0xFF092D51),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF579BD0).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String text;

  const _CategoryLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF064A72),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF00DDF5),
          fontSize: 9,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00DDF5), size: 16),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFF092747),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9BB8D4),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationItem extends StatelessWidget {
  final String title;
  final String description;

  const _VerificationItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF00DDB0),
          size: 15,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFB1C7DC),
                  fontSize: 9,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
