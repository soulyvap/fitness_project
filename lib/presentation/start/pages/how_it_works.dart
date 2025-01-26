import 'package:fitness_project/common/widgets/challenge_explanation.dart';
import 'package:fitness_project/presentation/start/pages/login.dart';
import 'package:fitness_project/presentation/start/widgets/explanation_text.dart';
import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How it works"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: explanations.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ExplanationText(
                    icon: e.icon,
                    title: e.title,
                    explanation: e.explanation,
                  ),
                );
              }).toList(),
            ),
            OutlinedButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChallengeExplanation(),
                      ),
                    ),
                child: const Text("More information on the points system")),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              ),
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}
