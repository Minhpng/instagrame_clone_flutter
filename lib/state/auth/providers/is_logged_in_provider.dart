import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/auth_result.dart';
import 'auth_state_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authResult = ref.watch(authStateProvider).result;
  return authResult == AuthResult.success;
});
