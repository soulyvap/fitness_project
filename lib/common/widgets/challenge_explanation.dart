import 'package:dotted_border/dotted_border.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:flutter/material.dart';

class ChallengeExplanation extends StatelessWidget {
  const ChallengeExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                  enableFeedback: false,
                  color: Colors.transparent,
                ),
                const Text('Challenge Scoring',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ScoreExplanationTile(scoreType: ScoreType.challengeCreation),
            const SizedBox(height: 8),
            Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey, width: 0.5)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: ScoreType.challengeParticipation.icon,
                        title: Text(ScoreType.challengeParticipation.title),
                        subtitle: Text(
                            ScoreType.challengeParticipation.explanation,
                            style: const TextStyle(fontSize: 11)),
                        trailing: Text(
                            ScoreType.challengeParticipation.value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Column(
                            children: ScoreType.values
                                .where((type) =>
                                    type.name.contains("Early") ||
                                    type.name.contains("Streak"))
                                .map((type) {
                              return ScoreExplanationTile(
                                scoreType: type,
                                isExtraPoints: true,
                              );
                            }).toList(),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const ScoreExplanationTile(
                scoreType: ScoreType.challengeParticipationAll)
          ],
        ),
      ),
    );
  }
}

class ScoreExplanationTile extends StatelessWidget {
  final ScoreType scoreType;
  final EdgeInsetsGeometry? margin;
  final bool isExtraPoints;

  const ScoreExplanationTile(
      {super.key,
      required this.scoreType,
      this.margin,
      this.isExtraPoints = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: isExtraPoints ? Colors.transparent : Colors.grey,
              width: 0.5)),
      child: ListTile(
        minVerticalPadding: isExtraPoints ? 2 : null,
        dense: isExtraPoints,
        leading: Transform.scale(
            scale: isExtraPoints ? 0.8 : 1, child: scoreType.icon),
        title: Text(scoreType.title),
        subtitle: isExtraPoints && scoreType.explanation == ""
            ? null
            : Text(scoreType.explanation, style: const TextStyle(fontSize: 11)),
        trailing: Text(
            isExtraPoints
                ? "+${scoreType.value.toString().padLeft(2, " ")}"
                : "${scoreType.value}",
            style: TextStyle(
              fontWeight: isExtraPoints ? FontWeight.normal : FontWeight.bold,
              fontSize: isExtraPoints ? 12 : 16,
            )),
      ),
    );
  }
}
