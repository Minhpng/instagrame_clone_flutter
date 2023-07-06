import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/views/components/dialog/alert_dialog_model.dart';
import 'package:instagram_clone_flutter/views/components/dialog/logout_dialog.dart';
import 'package:instagram_clone_flutter/views/tabs/user_posts/user_posts_view.dart';

import '../../state/auth/providers/auth_state_provider.dart';
import '../constants/strings.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.appName),
            actions: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.film),
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.add_a_photo_outlined),
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final shouldLogout = await LogoutDialog()
                      .present(context)
                      .then((value) => value ?? false);
                  if (shouldLogout) {
                    ref.read(authStateProvider.notifier).logOut();
                  }
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.home_filled),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              UserPostsView(),
              UserPostsView(),
              UserPostsView(),
            ],
          ),
        ));
  }
}
