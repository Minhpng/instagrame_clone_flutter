import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/comments/models/comment.dart';
import 'package:instagram_clone_flutter/state/comments/providers/delete_comment_notifier_provider.dart';
import 'package:instagram_clone_flutter/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_clone_flutter/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/dialog/alert_dialog_model.dart';
import 'package:instagram_clone_flutter/views/constants/strings.dart';

import '../dialog/delete_dialog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoModelProvider(comment.fromUserId));
    return userInfo.when(
        data: (data) {
          return ListTile(
            trailing: data.userId == comment.fromUserId
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final shouldDelete = await displayDeleteDialog(context);
                      if (shouldDelete) {
                        ref
                            .read(deleteCommentNotifierProvider.notifier)
                            .deleteComment(commentId: comment.commentId);
                      }
                    },
                  )
                : null,
            title: Text(data.displayName),
            subtitle: Text(comment.comment),
          );
        },
        error: (e, stacktrce) => const SmallErrorAnimationView(),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Future<bool> displayDeleteDialog(BuildContext context) {
    return const DeleteDialog(titleOfObjectToDelete: Strings.comments)
        .present(context)
        .then((value) => value ?? false);
  }
}
