import 'package:flutter/material.dart';

class ScoreSummaryRow extends StatelessWidget {
  final String title;
  final int points;
  final Widget? leading;
  const ScoreSummaryRow(
      {super.key, required this.title, required this.points, this.leading});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 0,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Text("$points points", style: const TextStyle(fontSize: 16)),
      leading: leading,
    );
  }
}
