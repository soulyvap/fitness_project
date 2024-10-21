import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/create_group/pages/create_group.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:fitness_project/presentation/home/widgets/add_group_tile.dart';
import 'package:fitness_project/presentation/home/widgets/group_tile.dart';
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
          const Text("Your groups",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: groups.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: index == groups.length
                      ? AddGroupTile(onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateGroupPage()));
                        })
                      : GroupTile(
                          group: groups[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GroupPage(group: groups[index]),
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
