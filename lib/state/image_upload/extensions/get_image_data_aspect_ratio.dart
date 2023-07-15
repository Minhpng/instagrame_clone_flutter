import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as mateiral show Image;
import 'package:instagram_clone_flutter/state/image_upload/extensions/get_image_aspect_ratio.dart';

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getImageAspectratio() {
    final image = mateiral.Image.memory(this);
    return image.getAspectRatio();
  }
}
