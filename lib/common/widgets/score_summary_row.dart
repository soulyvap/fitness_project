import 'package:flutter/material.dart';

class ScoreSummaryRow extends StatelessWidget {
  final String title;
  final int points;
  const ScoreSummaryRow({super.key, required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 0,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Text(points.toString(), style: const TextStyle(fontSize: 16)),
    );
  }
}
