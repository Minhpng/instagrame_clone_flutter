import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_flutter/state/auth/backend/authenticator.dart';
import 'package:instagram_clone_flutter/state/auth/models/auth_result.dart';

import '../models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();

  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
          result: AuthResult.success,
          isLoading: false,
          userId: _authenticator.userId);
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }
}
