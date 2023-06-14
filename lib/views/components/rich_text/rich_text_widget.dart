import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'base_text.dart';

import 'link_text.dart';

class RichTextWidget extends StatelessWidget {
  final Iterable<BaseText> basetexts;
  final TextStyle? styleForAll;
  const RichTextWidget({
    Key? key,
    required this.basetexts,
    this.styleForAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: basetexts.map((basetext) {
          if (basetext is LinkText) {
            return TextSpan(
                text: basetext.text,
                style: styleForAll?.merge(basetext.style),
                recognizer: TapGestureRecognizer()..onTap = basetext.onTapped);
          } else {
            return TextSpan(
              text: basetext.text,
              style: styleForAll?.merge(basetext.style),
            );
          }
        }).toList(),
      ),
    );
  }
}
