import 'package:fitness_project/domain/entities/auth/user.dart';
import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final UserEntity user;
  final void Function()? onTap;
  final Widget? trailing;
  const UserListTile(
      {super.key, required this.user, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: user.image == null
          ? Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.orangeAccent),
              child: Center(
                child: Text(user.displayName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            )
          : Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(user.image!), fit: BoxFit.cover)),
            ),
      trailing: trailing,
      title: Text(user.displayName),
      onTap: onTap,
    );
  }
}
