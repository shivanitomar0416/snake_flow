import 'package:flutter/material.dart';
class GameScore extends StatelessWidget {
  final int score;
  const GameScore({super.key, required this.score});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Text(
        "Score: $score",
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}
