import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  final GroupEntity group;
  final Widget? trailing;
  final Function()? onTap;
  const GroupListTile(
      {super.key, required this.group, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey,
          image: group.imageUrl == null
              ? null
              : DecorationImage(
                  image: NetworkImage(group.imageUrl!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(group.name),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
