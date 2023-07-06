// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import '../../image_upload/models/file_type.dart';
import '../../post_settings/models/post_setting.dart';
import 'post_key.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final DateTime createAt;
  final String thumbnailUrl;
  final String fileUrl;
  final FileType fileType;
  final String fileName;
  final double aspectRatio;
  final String thumbnailStorageId;
  final String originalFileStorageId;
  final Map<PostSetting, bool> postSettings;

  Post({required this.postId, required Map<String, dynamic> json})
      : userId = json[PostKey.userId],
        message = json[PostKey.message],
        createAt = (json[PostKey.createAt] as Timestamp).toDate(),
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        fileType = FileType.values.firstWhere(
            (fileType) => fileType.name == json[PostKey.fileType],
            orElse: () => FileType.image),
        fileName = json[PostKey.fileName],
        aspectRatio = json[PostKey.aspectRatio],
        thumbnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        postSettings = {
          for (var entry in json[PostKey.postSettings])
            PostSetting.values.firstWhere((e) => e.storageKey == entry.key):
                entry.value
        };

  bool get allowLikes => postSettings[PostSetting.allowLikes] ?? false;
  bool get allowComments => postSettings[PostSetting.allowComments] ?? false;
}
