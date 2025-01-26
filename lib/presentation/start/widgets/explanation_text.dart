import 'package:flutter/material.dart';

class ExplanationText extends StatelessWidget {
  final Widget icon;
  final String title;
  final String explanation;
  const ExplanationText(
      {super.key,
      required this.icon,
      required this.title,
      required this.explanation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: icon,
      title: Text(title),
      subtitle: Text(explanation),
    );
  }
}

class Explanation {
  final Widget icon;
  final String title;
  final String explanation;
  Explanation(
      {required this.icon, required this.title, required this.explanation});
}

const double iconSize = 48;

final List<Explanation> explanations = [
  Explanation(
    icon: const Icon(
      Icons.group,
      size: iconSize,
    ),
    title: "Create or join a group",
    explanation:
        "The group allows you and your friends to send each other challenges, earn points and compete on a leaderboard.",
  ),
  Explanation(
    icon: const Icon(Icons.fitness_center,
        size: iconSize, color: Colors.orangeAccent),
    title: "Challenge your friends",
    explanation:
        "Create short and fun challenges for your friends to complete. Challenges are time-limited and earn you points.\nYour friends receive a notification prompting them to complete the challenge before the deadline.",
  ),
  Explanation(
    icon: const Icon(Icons.check_circle, size: iconSize, color: Colors.green),
    title: "Take on challenges",
    explanation:
        "Complete challenges by submitting a video proof before the deadline. Earn more points by submitting early.",
  ),
  Explanation(
    icon: const Icon(Icons.leaderboard, size: iconSize, color: Colors.amber),
    title: "Climb the leaderboard",
    explanation:
        "Track your progress on the leaderboard. Earn points by initiating and completing challenges.",
  ),
  Explanation(
    icon: const Icon(Icons.thumb_up, size: iconSize, color: Colors.blue),
    title: "Review your friends' submissions",
    explanation:
        "Watch, like, and comment on your friends' submissions. Encourage them to keep moving!",
  ),
];
