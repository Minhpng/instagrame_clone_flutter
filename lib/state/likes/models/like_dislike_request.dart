// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;

import 'package:instagram_clone_flutter/state/posts/typedefs/post_id.dart';

import '../../posts/typedefs/user_id.dart';

@immutable
class LikeDislikeRequest {
  final PostId postId;
  final UserId userId;
  const LikeDislikeRequest({
    required this.postId,
    required this.userId,
  });
}
