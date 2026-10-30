import 'package:flutter/material.dart';
import 'package:meqyas/Api/PowerFactorApi.dart';
import 'package:meqyas/feature/pages/PowerFactor.dart';



class PowerFactorCard extends StatefulWidget {

  final void Function(Widget screen) onOpenExtraScreen;

  const PowerFactorCard({super.key, required this.onOpenExtraScreen});

  @override
  State<PowerFactorCard> createState() => _PowerFactorCardState();
}

class _PowerFactorCardState extends State<PowerFactorCard> {
  bool _loading = false;

  Future<void> _run() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final data = await PowerFactorService.runAnalysis();
      if (!mounted) return;
      widget.onOpenExtraScreen(PowerFactorScreen(data: data));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to run analysis: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: const Color(0xFFB3261E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5FA8), Color(0xFF123F73)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A78C4)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _run,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1FA56B),
                    shape: BoxShape.circle,
                  ),
                  // لو عندك أيقونة asset للـ radar ضيفها هنا بدل الأيقونة دي
                  child: const Icon(
                    Icons.track_changes,
                    color: Color(0xFFB8F5D6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Power Factor Intelligence',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Predictive monitoring of low power factor risk '
                            'over the next 3 hours.',
                        style: TextStyle(
                          color: Color(0xFFD3E2F2),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _loading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}