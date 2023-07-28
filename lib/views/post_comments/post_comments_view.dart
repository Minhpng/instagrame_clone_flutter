import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone_flutter/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_flutter/state/comments/providers/post_comment_provider.dart';
import 'package:instagram_clone_flutter/state/comments/providers/send_comment_notifier_provider.dart';
import 'package:instagram_clone_flutter/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone_flutter/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/comment/comment_tile.dart';
import 'package:instagram_clone_flutter/views/extensions/dismiss_keyboard.dart';

import '../constants/strings.dart';

// import '../components/constants/strings.dart';

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentsView({required this.postId, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();

    final hasText = useState(false);
    final request = useState(RequestForPostAndComments(
      postId: postId,
    ));

    final comments = ref.watch(postCommentsProvider(request.value));

    useEffect(() {
      void listener() {
        hasText.value = commentController.value.text.isNotEmpty;
      }

      commentController.addListener(listener);
      return () {
        commentController.removeListener(listener);
      };
    }, [commentController]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text(Strings.comments), actions: [
        IconButton(
          onPressed: hasText.value
              ? () {
                  _submitCommentWithController(commentController, ref);
                }
              : null,
          icon: const Icon(Icons.send),
        )
      ]),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            comments.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: EmptyContentsWithTextAnimationView(
                          text: Strings.noCommentsYet),
                    ),
                  );
                }
                return Expanded(
                  flex: 4,
                  child: RefreshIndicator(
                    onRefresh: () {
                      ref.invalidate(postCommentsProvider(request.value));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, i) {
                        return CommentTile(comment: comments.elementAt(i));
                      },
                    ),
                  ),
                );
              },
              loading: () => const LoadingAnimationView(),
              error: (e, stackTrace) => const ErrorAnimationView(),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: commentController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (commentMessage) {
                      if (commentMessage.isNotEmpty) {
                        _submitCommentWithController(commentController, ref);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.writeYourCommentHere,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

    final isSent =
        await ref.read(sendCommentNotifierProvider.notifier).sendComment(
              userId: userId,
              postId: postId,
              comment: controller.text,
            );

    if (isSent) {
      controller.clear();
      dismissKeyBoard();
    }
  }
}
