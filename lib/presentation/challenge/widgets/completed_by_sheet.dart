import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/presentation/challenge/bloc/completed_by_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedBySheet extends StatelessWidget {
  final List<String> userIds;
  final String authorId;
  const CompletedBySheet(
      {super.key, required this.userIds, required this.authorId});

  @override
  Widget build(BuildContext context) {
    final idsWithoutAuthor = userIds.where((id) => id != authorId).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: BlocProvider(
        create: (context) => CompletedByCubit(userIds: userIds)..loadData(),
        child: BlocBuilder<CompletedByCubit, CompletedByState>(
          builder: (context, state) {
            if (state is CompletedByLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed by (${state.users.length})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final isAuthor = user.userId == authorId;
                        final position =
                            idsWithoutAuthor.indexOf(user.userId) + 1;
                        final isOnPodium = [1, 2, 3].contains(position);
                        return ListTile(
                          trailing: Card(
                            color: isOnPodium
                                ? Theme.of(context).colorScheme.secondary
                                : isAuthor
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                  isOnPodium
                                      ? position.toOrdinal()
                                      : isAuthor
                                          ? "creator"
                                          : position.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            backgroundImage: user.image == null
                                ? null
                                : NetworkImage(user.image!),
                            child: user.image == null
                                ? Center(
                                    child:
                                        Text(user.displayName[0].toUpperCase()))
                                : null,
                          ),
                          title: Text(user.displayName),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
