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
  late int _timeLeft;
  late Timer _timer;

  @override
  void initState() {
    _timeLeft = widget.secondsLeft;
    startCountdown();
    super.initState();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        _timeLeft = _timeLeft - 1;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_timeLeft > 0)
              const Icon(Icons.hourglass_empty, color: Colors.white),
            Text(
              _timeLeft > 0 ? _timeLeft.secondsToTimeString() : 'ended',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
