import 'package:instagram_clone_flutter/enums/date_sorting.dart';
import 'package:instagram_clone_flutter/state/comments/models/comment.dart';
import 'package:instagram_clone_flutter/state/comments/models/post_comments_request.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocuments = toList()
        ..sort((a, b) {
          switch (request.dateSorting) {
            case DateSorting.newestOnTop:
              return a.createdAt.compareTo(b.createdAt);
            case DateSorting.oldestOnTop:
              return b.createdAt.compareTo(a.createdAt);
          }
        });
      return sortedDocuments;
    } else {
      return this;
    }
  }
}
