import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_flutter/state/posts/typedefs/post_id.dart';

final hasLikedProvider =
    StreamProvider.family.autoDispose<bool, PostId>((ref, PostId postId) {
  final userId = ref.watch(userIdProvider);

  if (userId == null) {
    return Stream<bool>.value(false);
  }

  final controller = StreamController<bool>();

  final hasLiked = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: postId)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isEmpty) {
      controller.add(false);
    } else {
      controller.add(true);
    }
  });

  ref.onDispose(() {
    hasLiked.cancel();
    controller.close();
  });

  return controller.stream;
});
