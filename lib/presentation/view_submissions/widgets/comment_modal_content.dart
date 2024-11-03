import 'package:fitness_project/domain/usecases/db/comment.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/comment_tile.dart';
import 'package:flutter/widgets.dart';

class CommentModalContent extends StatelessWidget {
  const CommentModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommentTile(
          comment: CommentEntity(
            userId: 'userId',
            createdAt: DateTime.now(),
            comment:
                "There weren't supposed to be dragons flying in the sky. First and foremost, dragons didn't exist. They were mythical creatures from fantasy books like unicorns. This was something that Pete knew in his heart to be true so he was having a difficult time acknowledging that there were actually fire-breathing dragons flying in the sky above him.",
            commentId: 'commentId',
            submissionId: 'submissionId',
          ),
        ),
      ],
    );
  }
}
