import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/views/components/animations/models/lottie_animation.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  const LottieAnimationView(
      {required this.animation,
      super.key,
      this.repeat = true,
      this.reverse = false});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animation.getFullPath,
      repeat: repeat,
      reverse: reverse,
    );
  }
}
