import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDateView extends StatelessWidget {
  final DateTime date;
  const PostDateView({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('d MMM, yyyy, h:mm a');
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(formatter.format(date)),
    );
  }
}
