import 'package:flutter/material.dart';

class buildHeader extends StatelessWidget {
  const buildHeader({super.key, required this.header});


    final String header;

  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
      child: Padding(
        padding:  EdgeInsets.all(9.5),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.maybePop(context),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 7, 7, 7),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 17),
              ),
            ),

             Expanded(
              child: Text(
                header,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF0A2947).withOpacity(.92),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(.12)),
              ),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white70,
                size: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
