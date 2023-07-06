import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';

import 'package:instagram_clone_flutter/views/components/dialog/alert_dialog_model.dart';

import '../constants/strings.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
            title: Strings.logOut,
            message: Strings.areYouSureThatYouwantToLogOut0fTheApp,
            buttons: const {
              Strings.cancel: false,
              Strings.logOut: true,
            });
}
