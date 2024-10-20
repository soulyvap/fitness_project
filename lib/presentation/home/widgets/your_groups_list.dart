import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:fitness_project/presentation/home/widgets/group_tiles.dart';
import 'package:flutter/material.dart';

class YourGroupsList extends StatelessWidget {
  final List<GroupEntity> groups;
  const YourGroupsList({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Groups",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GroupTile(
                      group: group,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupPage(group: group),
                          ),
                        );
                      }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
