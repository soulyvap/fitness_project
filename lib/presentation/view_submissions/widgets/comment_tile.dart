import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/domain/usecases/db/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

class CommentTile extends StatelessWidget {
  final CommentEntity comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
        create: (context) => UserCubit(),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if (state is UserInitial) {
            context.read<UserCubit>().loadUser(comment.userId);
          }
          if (state is! UserLoaded) {
            return Center(
              child: Text(state.toString()),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 16,
                backgroundImage: state.user.image != null
                    ? NetworkImage(state.user.image!)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${state.user.displayName} • ${comment.createdAt.toTimeAgo()}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    ReadMoreText(
                      comment.comment,
                      trimLines: 3,
                      colorClickableText: Theme.of(context).colorScheme.primary,
                      trimMode: TrimMode.Line,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          );
        }));
  }
}
