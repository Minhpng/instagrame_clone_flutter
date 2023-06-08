import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_flutter/state/user_info/models/user_info_payload.dart';

import '../../constants/firebase_collection_name.dart';
import '../../posts/typedefs/user_id.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      //check if user is already existed
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }

      final userPayload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email ?? '',
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(userPayload);
      return true;
    } catch (e) {
      return false;
    }
  }
}
