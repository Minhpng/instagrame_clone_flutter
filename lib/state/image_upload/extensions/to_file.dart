import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension ToFile on Future<XFile?> {
  Future<File?> toFile() {
    return then((xFile) => xFile?.path)
        .then((filePath) => filePath != null ? File(filePath) : null);
  }
}
