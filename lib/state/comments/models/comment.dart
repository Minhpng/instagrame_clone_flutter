import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_flutter/state/comments/typedef/commend_id.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_flutter/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone_flutter/state/posts/typedefs/user_id.dart';

@immutable
class Comment {
  final CommmentId commentId;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId;
  final PostId onPostId;
  Comment(Map<String, dynamic> json, {required this.commentId})
      : comment = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        fromUserId = json[FirebaseFieldName.userId],
        onPostId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is Comment &&
            runtimeType == other.runtimeType &&
            commentId == other.commentId &&
            comment == other.comment &&
            createdAt == other.createdAt &&
            fromUserId == other.fromUserId &&
            onPostId == other.onPostId;
  }

  @override
  int get hashCode => Object.hashAll([
        commentId,
        comment,
        createdAt,
        fromUserId,
        onPostId,
      ]);
}
