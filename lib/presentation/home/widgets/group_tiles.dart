import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final GroupEntity group;
  final Function onTap;
  const GroupTile({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            image: group.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(group.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Text(
            group.name,
            maxLines: 2,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  )
                ]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
