import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/rich_text/base_text.dart';
import '../components/rich_text/rich_text_widget.dart';

import '../constants/strings.dart';

class LoginViewSignUpLinks extends StatelessWidget {
  const LoginViewSignUpLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
        styleForAll:
            Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
        basetexts: [
          BaseText.plain(text: Strings.dontHaveAnAccount),
          BaseText.plain(text: Strings.signUpOn),
          BaseText.link(
              text: Strings.facebook,
              onTapped: () {
                launchUrl(
                  Uri.parse(Strings.facebookSignupUrl),
                );
              }),
          BaseText.plain(text: Strings.orCreateAnAccounton),
          BaseText.link(
              text: Strings.google,
              onTapped: () {
                launchUrl(
                  Uri.parse(Strings.googleSignupUrl),
                );
              }),
        ]);
  }
}
