import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/state/comments/models/comment.dart';
import 'package:instagram_clone_flutter/views/components/comment/compact_comment_tile.dart';

class CompactCommentColumn extends StatelessWidget {
  final Iterable<Comment> comments;
  const CompactCommentColumn({Key? key, required this.comments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...comments.map(
              (comment) => CompactCommentTile(comment: comment),
            ),
          ],
        ),
      );
    }
  }
}
