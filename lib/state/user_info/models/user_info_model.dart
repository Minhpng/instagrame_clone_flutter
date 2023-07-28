// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_flutter/state/constants/firebase_field_name.dart';

import 'package:instagram_clone_flutter/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoModel extends MapView<String, dynamic> {
  final UserId userId;
  final String displayName;
  final String? email;
  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? ''
        });

  UserInfoModel.fromJson(Map<String, dynamic> json, {required UserId userId})
      : this(
            userId: userId,
            displayName: json[FirebaseFieldName.displayName] ?? '',
            email: json[FirebaseFieldName.email] as String?);
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserInfoModel &&
            runtimeType == other.runtimeType &&
            userId == other.userId &&
            displayName == other.displayName &&
            email == other.email;
  }

  @override
  int get hashCode => Object.hashAll([userId, displayName, email]);
}
