import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 400,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(400),
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.1),
        ),
      );
  }
}