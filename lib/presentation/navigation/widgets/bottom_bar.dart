import 'package:fitness_project/common/widgets/start_a_challenge_sheet.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int navIndex;
  final Function(int) setIndex;
  final bool hasAGroup;
  const BottomBar(
      {super.key,
      required this.navIndex,
      required this.setIndex,
      required this.hasAGroup});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      onDestinationSelected: setIndex,
      selectedIndex: navIndex,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Find',
        ),
        const NavigationDestination(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        if (hasAGroup)
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isDismissible: false,
                isScrollControlled: true,
                builder: (context) => const StartAChallengeSheet(),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle,
                    color: Theme.of(context).colorScheme.secondary, size: 30),
                const SizedBox(height: 4),
                Text('Challenge',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )
      ],
    );
  }
}
