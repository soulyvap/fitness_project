import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:flutter/material.dart';

class ChallengedBy extends StatelessWidget {
  final UserEntity user;
  final Color? textColor;
  const ChallengedBy({super.key, required this.user, this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(
      children: [
        Text(
          "Challenged by",
          style: TextStyle(color: textColor, fontSize: 12),
        ),
        const SizedBox(width: 6),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
            image: user.image == null
                ? null
                : DecorationImage(
                    image: NetworkImage(user.image!),
                    fit: BoxFit.cover,
                  ),
          ),
          child: user.image == null
              ? Center(
                  child: Text(
                    user.displayName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          user.displayName,
          maxLines: 1,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 10, color: textColor),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ));
  }
}
