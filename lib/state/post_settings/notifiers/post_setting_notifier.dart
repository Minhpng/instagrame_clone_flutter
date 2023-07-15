import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/post_setting.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSetting, bool>> {
  PostSettingNotifier()
      : super(UnmodifiableMapView(
            {for (final setting in PostSetting.values) setting: true}));

  void setSetting(PostSetting setting, bool value) {
    final existingSetting = state[setting];
    if (existingSetting == null || existingSetting == value) return;
    state = Map.unmodifiable(Map.from(state)..[setting] = value);
  }
}
