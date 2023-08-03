import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/posts/models/post.dart';
import 'package:instagram_clone_flutter/views/components/animations/small_error_animation_view.dart';

import '../../state/likes/providers/post_like_count_provider.dart';
import 'constants/strings.dart';

class LikeCountView extends ConsumerWidget {
  final Post post;
  const LikeCountView({required this.post, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeCount = ref.watch(postLikeCountProvider(post.postId));

    return likeCount.when(
      data: (likeCount) {
        final peopleOrpersonText =
            likeCount == 1 ? Strings.person : Strings.people;

        final likesText = '$likeCount $peopleOrpersonText ${Strings.likedThis}';

        return Text(likesText);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
