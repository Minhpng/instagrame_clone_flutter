import 'package:flutter/material.dart';

class DividerWithMargins extends StatelessWidget {
  const DividerWithMargins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
