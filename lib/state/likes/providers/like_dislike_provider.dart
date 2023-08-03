import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_flutter/state/likes/models/Like.dart';
import 'package:instagram_clone_flutter/state/likes/models/like_dislike_request.dart';

final likeDislikeProvider = FutureProvider.family<bool, LikeDislikeRequest>(
    (ref, LikeDislikeRequest request) async {
  final query = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .where(FirebaseFieldName.userId, isEqualTo: request.userId)
      .get();

  final hasLiked = await query.then((snapshot) => snapshot.docs.isNotEmpty);

  if (hasLiked) {
    try {
      await query.then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  } else {
    final like = Like(
      date: DateTime.now(),
      postId: request.postId,
      userId: request.userId,
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.likes)
          .add(like);
      return true;
    } catch (e) {
      return false;
    }
  }
});
