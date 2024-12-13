import 'package:fitness_project/common/widgets/score_summary_row.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:flutter/material.dart';

class ScoreSummary extends StatelessWidget {
  final List<ScoreEntity> scores;
  final Widget? actionButton;
  const ScoreSummary({super.key, required this.scores, this.actionButton});

  @override
  Widget build(BuildContext context) {
    scores.sort((a, b) => a.type.index.compareTo(b.type.index));

    final total = scores.fold<int>(
        0, (previousValue, element) => previousValue + element.points);
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        children: [
          Row(
            children: [
              const Text("Points Earned",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const Spacer(),
              if (actionButton != null) actionButton!,
            ],
          ),
          const SizedBox(height: 16),
          ...scores.map((e) => ScoreSummaryRow(
                title: e.type.title,
                points: e.points,
                leading: e.type.icon,
              )),
          const Spacer(),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ScoreSummaryRow(title: "TOTAL", points: total),
        ],
      ),
    );
  }
}
