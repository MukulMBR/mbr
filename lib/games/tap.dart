import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(TapGameApp());

class TapGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TapGameScreen(),
    );
  }
}

class TapGameScreen extends StatefulWidget {
  @override
  _TapGameScreenState createState() => _TapGameScreenState();
}

class _TapGameScreenState extends State<TapGameScreen>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int timeLeft = 10;
  double targetSize = 50.0;
  double targetX = 0.0;
  double targetY = 0.0;
  Random random = Random();
  late Timer timer;
  bool isGameActive = true;

  @override
  void initState() {
    super.initState();
    startGame();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0 && isGameActive) {
          timeLeft--;
        } else {
          timer.cancel();
          if (isGameActive) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Text('Your score: $score'),
                  actions: [
                    ElevatedButton(
                      child: Text('Play Again'),
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
        }
      });
    });

    moveTarget();
  }

  void startGame() {
    score = 0;
    timeLeft = 10;
    targetSize = 50.0;
    isGameActive = true;
  }

  void stopGame() {
    setState(() {
      isGameActive = false;
    });
  }

  void moveTarget() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!isGameActive) {
        timer.cancel();
        return;
      }

      setState(() {
        targetX = random.nextDouble() * MediaQuery.of(context).size.width;
        targetY = random.nextDouble() * MediaQuery.of(context).size.height;
      });
    });
  }

  void onTapTarget() {
    setState(() {
      score++;
      targetSize += 10;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tap Game'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: targetX,
            top: targetY,
            child: GestureDetector(
              onTap: onTapTarget,
              child: Container(
                width: targetSize,
                height: targetSize,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Tap Me!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Text(
              'Time left: $timeLeft seconds',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            top: 60,
            right: 16,
            child: Text(
              'Score: $score',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            top: 100,
            right: 16,
            child: ElevatedButton(
              child: Text('Stop Game'),
              onPressed: stopGame,
            ),
          ),
        ],
      ),
    );
  }
}
