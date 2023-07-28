import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/comments/typedef/commend_id.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_flutter/state/image_upload/typedefs/is_loading.dart';

class DeleteCommentNotfier extends StateNotifier<IsLoading> {
  DeleteCommentNotfier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteComment({
    required CommmentId commentId,
  }) async {
    try {
      isLoading = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(FieldPath.documentId, isEqualTo: commentId)
          .limit(1)
          .get();

      await query.then((query) async {
        for (final doc in query.docs) {
          doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
