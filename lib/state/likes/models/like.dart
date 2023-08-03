// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;

import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_flutter/state/posts/typedefs/user_id.dart';

import '../../posts/typedefs/post_id.dart';

@immutable
class Like extends MapView<String, String> {
  final DateTime date;
  final PostId postId;
  final UserId userId;
  Like({
    required this.date,
    required this.postId,
    required this.userId,
  }) : super({
          FirebaseFieldName.date: date.toIso8601String(),
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.userId: userId,
        });
}
