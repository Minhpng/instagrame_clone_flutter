import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/comments/notifiers/delete_comment_notifier.dart';
import 'package:instagram_clone_flutter/state/image_upload/typedefs/is_loading.dart';

final deleteCommentNotifierProvider =
    StateNotifierProvider<DeleteCommentNotfier, IsLoading>(
  (_) => DeleteCommentNotfier(),
);
