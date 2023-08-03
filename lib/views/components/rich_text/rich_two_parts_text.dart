import 'package:flutter/material.dart';

class RichTwoPartsText extends StatelessWidget {
  final String leftPart;
  final String rightPart;

  const RichTwoPartsText(
      {Key? key, required this.leftPart, required this.rightPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white70,
          height: 1.5,
        ),
        children: [
          TextSpan(
              text: leftPart,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(
            text: ' $rightPart',
          ),
        ],
      ),
    );
  }
}
