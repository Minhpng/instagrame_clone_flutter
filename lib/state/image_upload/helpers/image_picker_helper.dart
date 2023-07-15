import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/state/image_upload/extensions/to_file.dart';

@immutable
class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() {
    return _picker.pickImage(source: ImageSource.gallery).toFile();
  }

  static Future<File?> pickVideoFromGallery() {
    return _picker.pickVideo(source: ImageSource.gallery).toFile();
  }
}
