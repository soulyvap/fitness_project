import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/models/db/edit_group_user_array_req.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/edit_group_user_array.dart';
import 'package:fitness_project/presentation/group/bloc/group_cubit.dart';
import 'package:fitness_project/presentation/group/bloc/members_cubit.dart';
import 'package:fitness_project/presentation/group/widgets/members_modal_content.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupHeader extends StatelessWidget {
  final GroupEntity group;
  final Function() onOpenModal;
  const GroupHeader(
      {super.key, required this.group, required this.onOpenModal});

  @override
  Widget build(BuildContext context) {
    final isMember = FirebaseAuth.instance.currentUser?.uid != null &&
        group.members.contains(FirebaseAuth.instance.currentUser!.uid);
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: group.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(group.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: group.imageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    group.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  subtitle: Text(
                    group.description,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  trailing: !isMember
                      ? null
                      : IconButton(
                          onPressed: () {
                            onOpenModal();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isMember)
                                          Card(
                                            child: ListTile(
                                                tileColor: Colors.red,
                                                onTap: () {},
                                                leading: const Icon(
                                                    Icons.exit_to_app,
                                                    color: Colors.white),
                                                title: const Text("Leave group",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                          ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.more_vert)),
                ),
                Builder(builder: (groupContext) {
                  return OutlinedButton.icon(
                      onPressed: () {
                        onOpenModal();
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return BlocProvider.value(
                                  value: groupContext.watch<MembersCubit>(),
                                  child: MembersModalContent(
                                    group: group,
                                    addAllowedUser: (userId) {
                                      groupContext
                                          .read<GroupCubit>()
                                          .addAllowedUser(userId);
                                    },
                                  ));
                            });
                      },
                      icon: const Icon(Icons.people),
                      label: Text(
                          "${group.members.length} member${group.members.length > 1 ? "s" : ""}"));
                }),
                // if (!isMember)
                //   ElevatedButton(
                //       onPressed: () async {
                //         final userId = FirebaseAuth.instance.currentUser?.uid;
                //         if (userId == null) return;
                //         await sl<EditGroupUserArrayUseCase>().call(
                //             params: EditGroupUserArrayReq(
                //                 groupId: group.groupId,
                //                 userId: userId,
                //                 groupUserArray: GroupUserArray.members,
                //                 groupArrayAction: GroupArrayAction.add));
                //         if (context.mounted) {
                //           context.read<GroupCubit>().loadData();
                //         }
                //       },
                //       child: const Text("Join")),
                // if (isMember)
                //   ElevatedButton(onPressed: () {}, child: const Text("Leave")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
