import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';

import '../models/post.dart';
import '../typedefs/search_term.dart';

final postsBySearchTermProvider = StreamProvider.family
    .autoDispose<Iterable<Post>, SearchTerm>((ref, SearchTerm searchTerm) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs
        .map(
          (post) => Post(
            postId: post.id,
            json: post.data(),
          ),
        )
        .where(
          (post) => post.message.toLowerCase().contains(
                searchTerm.toLowerCase(),
              ),
        );

    controller.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
