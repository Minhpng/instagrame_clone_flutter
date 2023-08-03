import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_flutter/state/posts/models/post.dart';
import 'package:instagram_clone_flutter/views/components/post/post_image_view.dart';

import 'post_video_view.dart';

class PostVideoOrImageView extends StatelessWidget {
  final Post post;
  const PostVideoOrImageView({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (post.fileType) {
      case FileType.image:
        return PostImageView(post: post);
      case FileType.video:
        return PostVideoView(post: post);
      default:
        return const SizedBox();
    }
  }
}
