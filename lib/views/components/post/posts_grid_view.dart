// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/views/components/post/post_thumbnail_view.dart';
import 'package:instagram_clone_flutter/views/post_detail/post_detail_view.dart';

import '../../../state/posts/models/post.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostsGridView({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: posts.length,
        itemBuilder: (_, index) {
          return PostThumbnailView(
              post: posts.elementAt(index),
              onTapped: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        PostDetailView(post: posts.elementAt(index)),
                  ),
                );
              });
        });
  }
}
