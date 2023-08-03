import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone_flutter/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_flutter/state/comments/providers/post_comment_provider.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';

import '../../comments/models/comment.dart';
import '../models/post.dart';
import '../models/post_with_comments.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComments, RequestForPostAndComments>(
        (ref, RequestForPostAndComments request) {
  final controller = StreamController<PostWithComments>();
  Post? post;
  Iterable<Comment>? comments;

  void notify() {
    final localPost = post;
    if (localPost == null) {
      return;
    }

    final outputComments = (comments ?? []).applySortingFrom(request);

    final postWithComments = PostWithComments(
      post: localPost,
      comments: outputComments,
    );
    controller.add(postWithComments);
  }

  final postSub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .where(FieldPath.documentId, isEqualTo: request.postId)
      .limit(1)
      .snapshots()
      .listen((postSnapshot) {
    if (postSnapshot.docs.isEmpty) {
      post = null;
      comments = null;
      notify();
      return;
    }

    final doc = postSnapshot.docs.first;

    if (doc.metadata.hasPendingWrites) return;

    post = Post(postId: doc.id, json: doc.data());
    notify();
  });

  final commentSub = ref.watch(postCommentsProvider(request));

  commentSub.whenData((cmts) {
    comments = cmts;
    notify();
  });

  ref.onDispose(() {
    postSub.cancel();
    controller.close();
  });

  return controller.stream;
});
