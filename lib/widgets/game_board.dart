import 'package:flutter/material.dart';
import 'package:snake_flow/widgets/tile_box.dart';

class GameBoard extends StatelessWidget {
  final int noOfRow;
  final int noOfColumn;
  final List<int> snakePosition;
  final int snakeHead;
  final int foodPosition;
  final List<int> borderList;

  const GameBoard({
    super.key,
    required this.noOfRow,
    required this.noOfColumn,
    required this.snakePosition,
    required this.snakeHead,
    required this.foodPosition,
    required this.borderList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: noOfRow * noOfColumn,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: noOfColumn,
      ),
      itemBuilder: (context, index) {
        return Tile_Box(
          index: index,
          snakeHead: snakeHead,
          snakePosition: snakePosition,
          foodPosition: foodPosition,
          borderList: borderList,
        );
      },
    );
  }
}
