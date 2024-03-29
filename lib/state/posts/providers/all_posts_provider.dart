import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';

import '../models/post.dart';

final allPostProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map(
      (doc) => Post(json: doc.data(), postId: doc.id),
    );

    controller.add(posts);
  });

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});
