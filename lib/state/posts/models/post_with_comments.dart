// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../comments/models/comment.dart';
import 'post.dart';

@immutable
class PostWithComments {
  final Post post;
  final Iterable<Comment> comments;
  const PostWithComments({
    required this.post,
    required this.comments,
  });

  @override
  bool operator ==(covariant PostWithComments other) {
    if (identical(this, other)) return true;

    return other.post == post &&
        const IterableEquality().equals(comments, other.comments);
  }

  @override
  int get hashCode => Object.hashAll([post, comments]);
}
