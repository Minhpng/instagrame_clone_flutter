import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_flutter/enums/date_sorting.dart';

import '../../posts/typedefs/post_id.dart';

@immutable
class RequestForPostAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestForPostAndComments({
    required this.postId,
    this.sortByCreatedAt = true,
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
  });

  @override
  bool operator ==(covariant RequestForPostAndComments other) {
    return postId == other.postId &&
        sortByCreatedAt == other.sortByCreatedAt &&
        dateSorting == other.dateSorting &&
        limit == other.limit;
  }

  @override
  int get hashCode => Object.hashAll([
        postId,
        sortByCreatedAt,
        dateSorting,
        limit,
      ]);
}
