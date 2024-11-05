import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupTileSmall extends StatelessWidget {
  final GroupEntity group;
  final Color? textColor;
  final Function()? onTap;
  const GroupTileSmall({
    super.key,
    required this.group,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: Colors.grey,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: group.imageUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(group.imageUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
              child: group.imageUrl == null
                  ? const Icon(
                      Icons.fitness_center,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            group.name,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      )),
    );
  }
}
