import 'package:fitness_project/common/widgets/start_a_challenge_sheet.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int navIndex;
  final Function(int) setIndex;
  const BottomBar({super.key, required this.navIndex, required this.setIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      NavigationBar(
        onDestinationSelected: setIndex,
        selectedIndex: navIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Find',
          ),
          SizedBox(
            width: 16,
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
      SizedBox(
        width: 68,
        height: 68,
        child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  backgroundColor: Colors.white,
                  builder: (context) => const StartAChallengeSheet());
            },
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              elevation: 4,
              child: const Icon(
                Icons.fitness_center,
                size: 32,
                color: Colors.white,
              ),
            )),
      )
    ]);
  }
}
