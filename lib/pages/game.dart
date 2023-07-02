import 'package:flutter/material.dart';
import 'package:mbr/games/tictactoe.dart';
import '../games/chess.dart';
import '../games/snake.dart';
import '../games/tap.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildGameButton(
                      context,
                      TicTacToePage(),
                      'res/ttt.jpg',
                      'Tic Tac Toe',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildGameButton(
                      context,
                      TapGameScreen(),
                      'res/tap.jpg',
                      'Tap',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: buildGameButton(
                      context,
                      SnakeGamePage(),
                      'res/snake.jpg',
                      'Snake',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildGameButton(
                      context,
                      MyHomePage(),
                      'res/chess.jpg',
                      'Chess',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGameButton(BuildContext context, Widget page, String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
