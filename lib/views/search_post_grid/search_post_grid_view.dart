import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/posts/typedefs/search_term.dart';
import 'package:instagram_clone_flutter/views/components/animations/data_not_found_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_flutter/views/components/post/posts_grid_view.dart';

import '../../state/posts/providers/posts_by_search_term_provider.dart';
import '../constants/strings.dart';

class SearchPostGridView extends ConsumerWidget {
  final SearchTerm searchTerm;
  const SearchPostGridView({required this.searchTerm, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const EmptyContentsWithTextAnimationView(
          text: Strings.enterYourSearchTerm);
    }
    final searchPost = ref.watch(postsBySearchTermProvider(searchTerm));

    return searchPost.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const DataNotFoundAnimationView();
        } else {
          return PostsGridView(posts: posts);
        }
      },
      error: (_, __) => const ErrorAnimationView(),
      loading: () => const LoadingAnimationView(),
    );
  }
}
