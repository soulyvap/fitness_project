import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/domain/usecases/db/comment.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CommentTile extends StatelessWidget {
  final CommentEntity comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${comment.userId} • ${comment.createdAt.toTimeAgo()}",
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
  }
}
