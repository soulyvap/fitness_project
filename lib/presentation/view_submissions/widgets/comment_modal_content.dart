import 'package:fitness_project/domain/usecases/db/comment.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/comments_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentModalContent extends StatefulWidget {
  final String submissionId;
  final Function(List<CommentEntity>)? onLoadComments;
  const CommentModalContent(
      {super.key, this.onLoadComments, required this.submissionId});

  @override
  State<CommentModalContent> createState() => _CommentModalContentState();
}

class _CommentModalContentState extends State<CommentModalContent> {
  final TextEditingController _commentController = TextEditingController();
  String? _commentError;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentsCubit>(
      create: (context) => CommentsCubit(submissionId: widget.submissionId),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5 +
            MediaQuery.of(context).viewInsets.bottom,
        child: BlocConsumer<CommentsCubit, CommentsState>(
            listener: (context, state) {
          if (state is CommentsLoaded) {
            widget.onLoadComments?.call(state.comments);
          }
        }, builder: (context, state) {
          if (state is! CommentsLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final comments = state.comments;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Comments (${comments.length})",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 16),
                    Expanded(
                      child: comments.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.comment,
                                      size: 48, color: Colors.grey),
                                  Text("No comments yet"),
                                ],
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return CommentTile(comment: comments[index]);
                              }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Add a comment",
                              errorText: _commentError,
                            ),
                            onChanged: (text) {
                              setState(() {
                                _commentError = null;
                              });
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_commentController.text.isEmpty) {
                                setState(() {
                                  _commentError = "Comment cannot be empty";
                                });
                                return;
                              }
                              context
                                  .read<CommentsCubit>()
                                  .addComment(_commentController.text);
                              _commentController.clear();
                            },
                            icon: const Icon(Icons.send))
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    )
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
