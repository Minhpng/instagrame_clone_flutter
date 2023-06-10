import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_flutter/state/auth/constants/constant.dart';

import '../../posts/typedefs/user_id.dart';
import '../models/auth_result.dart';

class Authenticator {
  const Authenticator();
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;
    if (token == null) return AuthResult.aborted;

    final oauthCredential = FacebookAuthProvider.credential(token);

    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;

      if (e.code != Constants.accountExistsWithDifferentCredential) {
        return AuthResult.failure;
      }
      if (email == null || credential == null) return AuthResult.failure;
      final provider =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (provider.contains(Constants.googleCom)) {
        await loginWithGoogle();
        FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);
    final signAccount = await googleSignIn.signIn();
    if (signAccount == null) return AuthResult.aborted;

    final googleAuth = await signAccount.authentication;
    final oauthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
