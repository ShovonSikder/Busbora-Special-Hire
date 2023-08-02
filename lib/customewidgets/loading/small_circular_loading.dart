import 'package:flutter/material.dart';

class SmallCircularLoading extends StatelessWidget {
  const SmallCircularLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 12,
      width: 12,
      child: CircularProgressIndicator(strokeWidth: 1),
    );
  }
}
