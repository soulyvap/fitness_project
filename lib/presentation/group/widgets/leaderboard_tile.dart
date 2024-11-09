import 'package:fitness_project/presentation/group/bloc/leaderboard_cubit.dart';
import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardItem item;
  const LeaderboardTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final difference = item.previousPosition == null
        ? 0
        : item.previousPosition! - item.position;
    return Row(
      children: [
        RankingIndicator(position: item.position),
        DifferenceIndicator(difference: difference),
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                backgroundImage: item.user.image == null
                    ? null
                    : NetworkImage(item.user.image!),
                child: item.user.image == null
                    ? Center(
                        child: Text(item.user.displayName[0].toUpperCase()))
                    : null,
              ),
              const SizedBox(width: 16),
              Text(item.user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(item.totalScore.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DifferenceIndicator extends StatelessWidget {
  final int difference;
  const DifferenceIndicator({super.key, required this.difference});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            difference == 0
                ? Icons.remove
                : difference > 0
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
            color: difference == 0
                ? Colors.grey
                : difference > 0
                    ? Colors.green
                    : Colors.red,
            size: 16,
          ),
          if (difference != 0)
            Text(
              difference.abs().toString(),
              style: const TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }
}

class RankingIndicator extends StatelessWidget {
  final int position;
  const RankingIndicator({super.key, required this.position});
  List<(Color, Color)> colors() => [
        (
          const Color.fromARGB(255, 255, 234, 98),
          const Color.fromARGB(255, 253, 156, 0)
        ),
        (
          const Color.fromARGB(255, 218, 226, 235),
          const Color.fromARGB(255, 146, 163, 185)
        ),
        (
          const Color.fromARGB(255, 249, 191, 140),
          const Color.fromARGB(255, 197, 124, 39)
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (position < 4)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors()[position - 1].$1,
                border: Border(
                  top: BorderSide(color: colors()[position - 1].$2, width: 1),
                  bottom:
                      BorderSide(color: colors()[position - 1].$2, width: 1),
                  left: BorderSide(color: colors()[position - 1].$2, width: 1),
                  right: BorderSide(color: colors()[position - 1].$2, width: 1),
                ),
              ),
            ),
          Text(
            position.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: position < 4 ? colors()[position - 1].$2 : Colors.grey,
                shadows: const []),
          ),
        ],
      ),
    );
  }
}
