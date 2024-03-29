import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_flutter/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instagram_clone_flutter/state/image_upload/typedefs/is_loading.dart';

import '../models/post.dart';
import '../typedefs/post_id.dart';

class DeletePostNotifier extends StateNotifier<IsLoading> {
  DeletePostNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deletePost(Post post) async {
    try {
      isLoading = true;

      await Future.wait([
        FirebaseStorage.instance
            .ref()
            .child(post.userId)
            .child(FirebaseCollectionName.thumbnails)
            .child(post.thumbnailStorageId)
            .delete(),
        FirebaseStorage.instance
            .ref()
            .child(post.userId)
            .child(post.fileType.collectionName)
            .child(post.originalFileStorageId)
            .delete(),
        _deleteAllDocuments(
          inCollection: FirebaseCollectionName.likes,
          postId: post.postId,
        ),
        _deleteAllDocuments(
          inCollection: FirebaseCollectionName.comments,
          postId: post.postId,
        )
      ]);

      // delete post thumbnail
      // final done = await FirebaseStorage.instance
      //     .ref()
      //     .child(post.userId)
      //     .child(FirebaseCollectionName.thumbnails)
      //     .child(post.thumbnailStorageId)
      //     .delete();

      // // delete post original image/video
      // await FirebaseStorage.instance
      //     .ref()
      //     .child(post.userId)
      //     .child(post.fileType.collectionName)
      //     .child(post.originalFileStorageId)
      //     .delete();

      // // delete post likes
      // await _deleteAllDocuments(
      //   inCollection: FirebaseCollectionName.likes,
      //   postId: post.postId,
      // );

      // // delete post comments
      // await _deleteAllDocuments(
      //   inCollection: FirebaseCollectionName.comments,
      //   postId: post.postId,
      // );

      // delete post itself
      final posts = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(FieldPath.documentId, isEqualTo: post.postId)
          .limit(1)
          .get();

      for (final post in posts.docs) {
        post.reference.delete();
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments({
    required PostId postId,
    required String inCollection,
  }) async {
    FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(FirebaseFieldName.postId, isEqualTo: postId)
            .get();

        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}
