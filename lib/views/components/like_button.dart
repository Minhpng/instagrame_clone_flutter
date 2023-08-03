import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone_flutter/state/likes/models/like_dislike_request.dart';
import 'package:instagram_clone_flutter/state/likes/providers/has_liked_provider.dart';
import 'package:instagram_clone_flutter/state/likes/providers/like_dislike_provider.dart';
import 'package:instagram_clone_flutter/views/components/animations/small_error_animation_view.dart';

import '../../state/posts/typedefs/post_id.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;
  const LikeButton({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedProvider(postId));
    return hasLiked.when(
      data: (hasLiked) {
        final icon =
            hasLiked ? (FontAwesomeIcons.solidHeart) : (FontAwesomeIcons.heart);

        return IconButton(
          icon: Icon(icon),
          onPressed: () {
            final userId = ref.read(userIdProvider);

            if (userId == null) return;
            final request = LikeDislikeRequest(postId: postId, userId: userId);
            ref.read(likeDislikeProvider(request));
          },
        );
      },
      error: (e, stacktrace) => const SmallErrorAnimationView(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
