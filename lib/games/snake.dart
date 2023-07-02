import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int gridSize = 20;
  static const int snakeSpeed = 200;

  List<int> snake = [44, 45, 46];
  int food = 48;
  Direction direction = Direction.right;
  bool isPlaying = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    snake = [44, 45, 46];
    food = 48;
    direction = Direction.right;
    isPlaying = true;
    timer = Timer.periodic(Duration(milliseconds: snakeSpeed), (Timer t) {
      setState(() {
        moveSnake();
        checkCollision();
      });
    });
  }

  void moveSnake() {
    final head = snake.last;
    int nextCell = 0;
    switch (direction) {
      case Direction.up:
        nextCell = head - gridSize;
        break;
      case Direction.down:
        nextCell = head + gridSize;
        break;
      case Direction.left:
        nextCell = head - 1;
        break;
      case Direction.right:
        nextCell = head + 1;
        break;
    }
    snake.add(nextCell);
    if (nextCell != food) {
      snake.removeAt(0);
    } else {
      generateFood();
    }
  }

  void generateFood() {
    final random = Random();
    int newFood = random.nextInt(gridSize * gridSize);
    while (snake.contains(newFood)) {
      newFood = random.nextInt(gridSize * gridSize);
    }
    food = newFood;
  }

  void checkCollision() {
    final head = snake.last;
    if (snake.length > 1 && snake.getRange(0, snake.length - 1).contains(head)) {
      gameOver();
    }
    if (head < 0 ||
        head >= gridSize * gridSize ||
        (direction == Direction.left && head % gridSize == gridSize - 1) ||
        (direction == Direction.right && head % gridSize == 0)) {
      gameOver();
    }
  }

  void gameOver() {
    isPlaying = false;
    timer?.cancel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Would you like to play again?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
          ],
        );
      },
    );
  }

  void changeDirection(Direction newDirection) {
    if ((newDirection == Direction.up && direction != Direction.down) ||
        (newDirection == Direction.down && direction != Direction.up) ||
        (newDirection == Direction.left && direction != Direction.right) ||
        (newDirection == Direction.right && direction != Direction.left)) {
      direction = newDirection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              changeDirection(Direction.up);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              changeDirection(Direction.down);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              changeDirection(Direction.left);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              changeDirection(Direction.right);
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: gridSize * gridSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (snake.contains(index)) {
                    return Container(
                      color: Colors.green,
                    );
                  } else if (index == food) {
                    return Container(
                      color: Colors.red,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection(Direction.up),
                  child: Icon(Icons.arrow_upward),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection(Direction.left),
                  child: Icon(Icons.arrow_back),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => changeDirection(Direction.right),
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection(Direction.down),
                  child: Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

enum Direction { up, down, left, right }
