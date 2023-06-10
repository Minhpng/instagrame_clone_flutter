import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone_flutter/state/auth/providers/auth_state_provider.dart';
import 'firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state/auth/providers/is_logged_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          return isLoggedIn ? const MainView() : const LoginView();
        },
      ),
    );
  }
}

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home Page',
        ),
      ),
      body: TextButton(
        onPressed: ref.read(authStateProvider.notifier).logOut,
        child: const Text('Logout'),
      ),
    );
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
            child: const Text('Log in with Google'),
          ),
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
            child: const Text('Log in with Facebook'),
          ),
        ],
      ),
    );
  }
}
