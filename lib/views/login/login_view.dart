import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_flutter/views/login/divider_with_margins.dart';
import 'package:instagram_clone_flutter/views/login/facebook_button.dart';
import 'package:instagram_clone_flutter/views/login/google_button.dart';
import 'package:instagram_clone_flutter/views/login/login_views_signup_links.dart';

import '../constants/app_colors.dart';
import '../constants/strings.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                Strings.welcomeToAppName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const DividerWithMargins(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).loginWithGoogle();
                },
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.loginButtonColor,
                    foregroundColor: AppColors.loginButtonTextColor),
                child: const GoogleSignInButton(),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).loginWithFacebook();
                },
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.loginButtonColor,
                    foregroundColor: AppColors.loginButtonTextColor),
                child: const FacebookSignInButton(),
              ),
              const DividerWithMargins(),
              const LoginViewSignUpLinks()
            ],
          ),
        ),
      ),
    );
  }
}
