import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/enums/date_sorting.dart';
import 'package:instagram_clone_flutter/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_flutter/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instagram_clone_flutter/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:instagram_clone_flutter/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/dialog/alert_dialog_model.dart';
import 'package:instagram_clone_flutter/views/components/like_button.dart';
import 'package:instagram_clone_flutter/views/components/likes_count_view.dart';
import 'package:instagram_clone_flutter/views/components/post/post_date_view.dart';
import 'package:instagram_clone_flutter/views/components/post/post_video_or_image_view.dart';
import 'package:instagram_clone_flutter/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../state/posts/models/post.dart';
import '../../state/posts/providers/delete_post_provider.dart';
import '../components/comment/compact_comment_column.dart';
import '../components/dialog/delete_dialog.dart';
import '../components/post/post_display_name_and_message.dart';
import '../constants/strings.dart';

class PostDetailView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailView({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );
    final postWithComments =
        ref.watch(specificPostWithCommentsProvider(request));

    final canDeletePost =
        ref.watch(canCurrentUserDeletePostProvider(widget.post));

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        actions: [
          // share button
          postWithComments.when(
            data: (postWithComment) {
              return IconButton(
                onPressed: () {
                  final url = postWithComment.post.fileUrl;
                  Share.share(url, subject: Strings.checkOutThisPost);
                },
                icon: const Icon(Icons.share),
              );
            },
            error: (_, __) => const SmallErrorAnimationView(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          if (canDeletePost.value ?? false)
            IconButton(
                onPressed: () async {
                  final shouldDelete = await const DeleteDialog(
                          titleOfObjectToDelete: Strings.post)
                      .present(context)
                      .then((value) => value ?? false);
                  if (shouldDelete) {
                    final deleteSuccess = await ref
                        .read(deletePostProvider.notifier)
                        .deletePost(widget.post);
                    if (!deleteSuccess) return;
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: const Icon(Icons.delete))
        ],
      ),
      body: postWithComments.when(
        data: (postWithComments) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostVideoOrImageView(post: widget.post),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.post.allowLikes)
                        LikeButton(postId: widget.post.postId),
                      if (widget.post.allowComments)
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PostCommentsView(
                                    postId: widget.post.postId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.comment_outlined),
                        ),
                    ],
                  ),
                ),
                PostDisplayNameAndMessage(post: widget.post),
                PostDateView(date: widget.post.createAt),
                if (postWithComments.comments.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white70,
                    ),
                  ),
                CompactCommentColumn(
                  comments: postWithComments.comments,
                ),
                if (widget.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LikeCountView(post: widget.post),
                  ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
        error: (_, __) => const SmallErrorAnimationView(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
