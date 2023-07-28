import 'package:flutter/material.dart';

extension DismissKeyboard on Widget {
  void dismissKeyBoard() => FocusManager.instance.primaryFocus?.unfocus();
}
