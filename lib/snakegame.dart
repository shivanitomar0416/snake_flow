import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'widgets/game_board.dart';
import 'widgets/game_score.dart';

enum Direction { up, down, left, right }

class Snakegamepage extends StatefulWidget {
  const Snakegamepage({super.key});

  @override
  State<Snakegamepage> createState() => _SnakegamepageState();
}

class _SnakegamepageState extends State<Snakegamepage> {
  int boxSize = 20;
  int noOfRow = 0, noOfColumn = 0;
  List<int> borderList = [];
  List<int> snakePosition = [];
  int snakeHead = 0;
  int score = 0;
  late int foodPosition;
  late FocusNode focusNode;
  late Direction direction;
  late Timer gameTimer;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    gameTimer.cancel();
    super.dispose();
  }

  void startGame() {
    score = 0;
    makeBorder();
    generateFood();
    direction = Direction.right;
    snakePosition = [
      noOfColumn * 5 + 5,
      noOfColumn * 5 + 4,
      noOfColumn * 5 + 3,
    ];
    snakeHead = snakePosition.first;
    gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      updateSnake();
      if (checkCollision()) {
        timer.cancel();
        showDialogBox();
      }
    });
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text(
            "Your Score is $score",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  bool checkCollision() {
    if (borderList.contains(snakeHead)) return true;
    if (snakePosition.sublist(1).contains(snakeHead)) return true;
    return false;
  }

 void generateFood() {
  int newFood;
  do {
    newFood = Random().nextInt(noOfRow * noOfColumn); // safer full-board range
  } while (borderList.contains(newFood) || snakePosition.contains(newFood));
  foodPosition = newFood;
}


  void updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          snakePosition.insert(0, snakeHead - noOfColumn);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHead + noOfColumn);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead + 1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead - 1);
          break;
      }
    });

    if (snakeHead == foodPosition) {
      score++;
      generateFood();
    } else {
      snakePosition.removeLast();
    }
    snakeHead = snakePosition.first;
  }

  void handledkey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          if (direction != Direction.down) direction = Direction.up;
          break;
        case LogicalKeyboardKey.arrowDown:
          if (direction != Direction.up) direction = Direction.down;
          break;
        case LogicalKeyboardKey.arrowLeft:
          if (direction != Direction.right) direction = Direction.left;
          break;
        case LogicalKeyboardKey.arrowRight:
          if (direction != Direction.left) direction = Direction.right;
          break;
      }
    }
  }

 void makeBorder() {
  borderList.clear();

  // Top border
  for (int i = 0; i < noOfColumn; i++) {
    borderList.add(i);
  }

  // Bottom border
  for (int i = (noOfRow - 1) * noOfColumn; i < noOfRow * noOfColumn; i++) {
    borderList.add(i);
  }

  // Left and Right borders
  for (int i = 0; i < noOfRow; i++) {
    borderList.add(i * noOfColumn); // Left
    borderList.add((i + 1) * noOfColumn - 1); // Right
  }
}


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    noOfRow = ((screenHeight - 60) ~/ boxSize);
    noOfColumn = (screenWidth ~/ boxSize);
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: focusNode,
        onKey: handledkey,
        autofocus: true,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < 0 && direction != Direction.down) {
              direction = Direction.up;
            } else if (details.delta.dy > 0 && direction != Direction.up){
              direction = Direction.down;
          }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < 0 && direction != Direction.right)
              direction = Direction.left;
            else if (details.delta.dx > 0 && direction != Direction.left)
              direction = Direction.right;
          },
          child: Column(
            children: [
              GameScore(score: score),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (snakePosition.isEmpty) startGame();
                    return GameBoard(
                      noOfRow: noOfRow,
                      noOfColumn: noOfColumn,
                      snakePosition: snakePosition,
                      snakeHead: snakeHead,
                      foodPosition: foodPosition,
                      borderList: borderList,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
