import 'package:flutter/material.dart';

class Tile_Box extends StatelessWidget {
  final int index;
  final int snakeHead;
  final List<int> snakePosition;
  final int foodPosition;
  final List<int> borderList;
  const Tile_Box({
    super.key,
    required this.index,
    required this.snakeHead,
    required this.snakePosition,
    required this.foodPosition,
    required this.borderList,
  });
  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    if (borderList.contains(index)) {
      color = Colors.blue;
    } else if (snakePosition.contains(index)) {
      color = (snakeHead == index) ? Colors.green : Colors.black;
    } else if (index == foodPosition) {
      color = Colors.red;
    }
    return Container(color: color, margin: const EdgeInsets.all(0.5));
  }
}
