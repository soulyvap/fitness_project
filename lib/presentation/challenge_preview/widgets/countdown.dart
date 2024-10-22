import 'dart:async';

import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final int secondsLeft;
  const Countdown({super.key, required this.secondsLeft});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int timeLeft;

  @override
  void initState() {
    timeLeft = widget.secondsLeft;
    startCountdown();
    super.initState();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        timeLeft = timeLeft - 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_full, color: Colors.white),
            Text(
              timeLeft.secondsToTimeString(),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
