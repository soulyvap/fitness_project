import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/group/widgets/group_header.dart';
import 'package:flutter/material.dart';

class GroupInfoTab extends StatelessWidget {
  final GroupEntity group;
  const GroupInfoTab({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [GroupHeader(group: group)],
        ),
      ),
    );
  }
}
