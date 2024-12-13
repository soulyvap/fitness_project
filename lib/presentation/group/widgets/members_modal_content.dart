import 'package:fitness_project/common/widgets/user_autocomplete.dart';
import 'package:fitness_project/data/models/db/edit_group_user_array_req.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/usecases/db/edit_group_user_array.dart';
import 'package:fitness_project/presentation/create_group/widgets/user_list_tile.dart';
import 'package:fitness_project/presentation/group/bloc/members_cubit.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersModalContent extends StatelessWidget {
  final GroupEntity group;
  final Function(List<String>)? onLoadMembers;
  final Function(String) addAllowedUser;
  const MembersModalContent(
      {super.key,
      required this.group,
      this.onLoadMembers,
      required this.addAllowedUser});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (groupContext) {
      final membersState = groupContext.watch<MembersCubit>().state;
      if (membersState is MembersInitial) {
        groupContext.read<MembersCubit>().loadData();
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (membersState is MembersError) {
        return Center(
          child: Text(membersState.message),
        );
      } else if (membersState is MembersLoaded) {
        final allowed = membersState.members;
        final active = allowed
            .where((element) => group.members.contains(element.userId))
            .toList();
        final pending = allowed
            .where((element) => !group.members.contains(element.userId))
            .toList();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // FilledButton.icon(
                  //     icon: const Icon(Icons.qr_code, size: 16),
                  //     style: const ButtonStyle(
                  //         backgroundColor: WidgetStatePropertyAll(
                  //       Colors.grey,
                  //     )),
                  //     onPressed: () {},
                  //     label: const Text("Show QR",
                  //         style: TextStyle(fontSize: 12))),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                  // FilledButton.icon(
                  //     icon: const Icon(Icons.copy, size: 16),
                  //     onPressed: () {},
                  //     label: const Text("Copy link",
                  //         style: TextStyle(fontSize: 12))),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                  Expanded(
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                          Theme.of(groupContext).colorScheme.secondary,
                        )),
                        onPressed: () {
                          showModalBottomSheet(
                              context: groupContext,
                              isScrollControlled: true,
                              builder: (context) {
                                return UserAutocomplete(
                                  onSelectUser: (user) {
                                    if (group.allowedUsers
                                        .contains(user.userId)) {
                                      return;
                                    }
                                    groupContext
                                        .read<MembersCubit>()
                                        .addMember(user);
                                    sl<EditGroupUserArrayUseCase>().call(
                                        params: EditGroupUserArrayReq(
                                      groupId: group.groupId,
                                      userId: user.userId,
                                      groupUserArray:
                                          GroupUserArray.allowedUsers,
                                      groupArrayAction: GroupArrayAction.add,
                                    ));
                                    addAllowedUser(user.userId);
                                  },
                                  usersAdded: groupContext
                                          .watch<MembersCubit>()
                                          .state is MembersLoaded
                                      ? (groupContext
                                              .watch<MembersCubit>()
                                              .state as MembersLoaded)
                                          .members
                                          .toList()
                                      : [],
                                );
                              });
                        },
                        label: const Text("Invite",
                            style: TextStyle(fontSize: 12))),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Members (${allowed.length})",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: MediaQuery.of(groupContext).size.height * 0.4,
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 4,
                  ),
                  itemCount: allowed.length,
                  itemBuilder: (context, index) {
                    final member = [...active, ...pending][index];
                    final isAdmin = group.admins.contains(member.userId);
                    final isPending = !group.members.contains(member.userId);
                    return UserListTile(
                        user: member,
                        trailing: isAdmin
                            ? Card(
                                color: Theme.of(context).colorScheme.secondary,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    "admin",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ))
                            : isPending
                                ? Card(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        "pending",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ))
                                : null);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
