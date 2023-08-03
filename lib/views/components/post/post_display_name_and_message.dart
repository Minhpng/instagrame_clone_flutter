import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/posts/models/post.dart';
import 'package:instagram_clone_flutter/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_clone_flutter/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/rich_text/rich_two_parts_text.dart';

class PostDisplayNameAndMessage extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMessage({required this.post, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(userInfoModelProvider(post.userId));
    return userInfoModel.when(
      data: (userInfo) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichTwoPartsText(
              leftPart: userInfo.displayName, rightPart: post.message),
        );
      },
      error: ((error, stackTrace) => const SmallErrorAnimationView()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
