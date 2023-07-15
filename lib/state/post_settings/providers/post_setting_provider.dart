import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/post_setting_notifier.dart';
import '../models/post_setting.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingNotifier(),
);
