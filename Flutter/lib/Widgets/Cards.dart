import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/Widgets/chartLabel.dart';
import 'package:meqyas/Widgets/text_feild.dart';
import 'package:meqyas/feature/pages/anomalies_screen.dart';
class statCard extends StatelessWidget {
  const statCard({
    super.key,
    required this.title,
    required this.value,
    this.showLastRow = true,
    required this.color,
    this.CircleAvatarcolor,
    this.image1 = "assets/Vector (9).png",
    this.image2 = "assets/Vector (8).png",  this.color2=Appcolor.green, required this.iconimage, this.Heigh=90,

  });
  final Color? CircleAvatarcolor;
  final String title;
  final String value;
  final bool showLastRow;
  final Color color;
  final String image1;
  final String image2;
  final String iconimage;
  final Color color2;
  final double Heigh;
  
  @override
  Widget build(BuildContext context) {

    return Container(
      height: Heigh,
width:double.infinity,
      child: card(

        child: Row(
          spacing: 5,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: CircleAvatarcolor,
              radius: 16,
              child: Image.asset(iconimage),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                SizedBox(height: 7),

                if (showLastRow)
                  Row(
                    children: [
                      Image.asset(image1, height: 10),
                      Text(
                        " 12% vs Last month ",
                        style: TextStyle(fontSize: 7, color: color2),
                      ),
                      Image.asset(image2, height: 10),
                    ],
                  ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}

Widget card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xE8153967),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );
}




class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Consumption Trend'),
        const SizedBox(height: 4),
        const Text(
          'Daily energy consumption',
          style: TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 115,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [35.0, 60.0, 45.0, 80.0, 50.0, 70.0, 40.0]
                .asMap()
                .entries
                .map((entry) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Container(
                    height: entry.value,
                    decoration: BoxDecoration(
                      color: entry.key == 3
                          ? Appcolor.green
                          : Appcolor.lightBlue.withValues(alpha: 0.8),
                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ),
                ),
              );
            })
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            chartLabel('Mon'),
            chartLabel('Tue'),
            chartLabel('Wed'),
            chartLabel('Thu'),
            chartLabel('Fri'),
            chartLabel('Sat'),
            chartLabel('Sun'),
          ],
        ),
      ],
    );
  }
}

class generalHomeCard extends StatelessWidget {
  const generalHomeCard({
    super.key, required this.Title, required this.Subtext, required this.icon, required this.iconcolor, this.ontap,  this.price, required this.IconImage, required this.cyrcleavatarcolor,
  });
  final String Title;
  final String Subtext;
  final String IconImage;
  final String ?price;
  final IconData icon;
   final Color iconcolor;
  final VoidCallback? ontap;
  final Color cyrcleavatarcolor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: cyrcleavatarcolor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(IconImage),
                ),
                const SizedBox(width: 9),
                 Expanded(
                  child: Text(
                    Title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
            if (Title == "Potential Monthly Savings") ...[
              Padding(
                padding: EdgeInsets.only(left: 36, top: 2),
                child: Text(
                  price!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],


              Padding(
              padding: EdgeInsets.only(left: 36, top: 2),
              child: Text(
                Subtext,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (Title == "Active Anomalies")
             Wrap(
              spacing: 40,
              runSpacing: 7,
              children: [
                _SeverityChip(
                  label: '2 High',
                  color: Color(0xFFB92F3A),
                ),
                _SeverityChip(
                  label: '2 Medium',
                  color: Color(0xFFFFA45B),
                ),
                _SeverityChip(
                  label: '1 Low',
                  color: Color(0xFF244FC4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SeverityChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}