import 'package:fitness_project/presentation/view_submissions/widgets/comment_modal_content.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final String submissionId;
  final Function(int) updateCommentCount;
  final int commentCount;

  const CommentButton(
      {super.key,
      required this.submissionId,
      required this.updateCommentCount,
      required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => CommentModalContent(
                  submissionId: submissionId,
                  onLoadComments: (comments) =>
                      updateCommentCount(comments.length),
                ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.comment, size: 24, color: Colors.white, shadows: [
              Shadow(
                color: Colors.white,
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ]),
            Text("$commentCount",
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
