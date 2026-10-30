import 'package:flutter/material.dart';

class chartLabel extends StatelessWidget {
  final String label;

  const chartLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white54, fontSize: 9),
    );
  }
}