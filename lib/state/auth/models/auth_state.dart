import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_flutter/state/auth/models/auth_result.dart';

import '../../posts/typedefs/user_id.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;
  AuthState copiedWithIsLoading(bool isLoading) {
    return AuthState(
      result: result,
      isLoading: isLoading,
      userId: userId,
    );
  }

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (isLoading == other.isLoading &&
          result == other.result &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(result, userId, isLoading);
}
