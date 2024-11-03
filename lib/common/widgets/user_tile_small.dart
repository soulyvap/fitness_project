import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:flutter/material.dart';

class UserTileSmall extends StatelessWidget {
  final String? leadingText;
  final UserEntity user;
  final Color? textColor;
  const UserTileSmall(
      {super.key, required this.user, this.textColor, this.leadingText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(
      children: [
        if (leadingText != null)
          Text(
            leadingText!,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
        const SizedBox(width: 6),
        Container(
          width: 24,
          height: 24,
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
              fontWeight: FontWeight.bold, fontSize: 12, color: textColor),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ));
  }
}
