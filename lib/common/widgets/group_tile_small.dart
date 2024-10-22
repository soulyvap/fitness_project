import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupTileSmall extends StatelessWidget {
  final GroupEntity group;
  final Color? textColor;
  const GroupTileSmall({
    super.key,
    required this.group,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 110,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                image: group.imageUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(group.imageUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
              child: group.imageUrl == null ? const Icon(Icons.group) : null,
            ),
            const SizedBox(width: 6),
            Text(
              group.name,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 10, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
