import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
    currentPlayer = 'X';
    gameOver = false;
  }

  void makeMove(int row, int col) {
    if (board[row][col] == '' && !gameOver) {
      setState(() {
        board[row][col] = currentPlayer;
        checkGameOver(row, col);
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });
    }
  }

  void checkGameOver(int row, int col) {
    // Check row
    if (board[row][0] == board[row][1] && board[row][1] == board[row][2] && board[row][0] != '') {
      gameOver = true;
    }
    // Check column
    if (board[0][col] == board[1][col] && board[1][col] == board[2][col] && board[0][col] != '') {
      gameOver = true;
    }
    // Check diagonals
    if ((board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != '') ||
        (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != '')) {
      gameOver = true;
    }
    // Check for draw
    if (!gameOver && !board.any((row) => row.any((cell) => cell == ''))) {
      gameOver = true;
    }
  }

  Widget buildBoard() {
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 3; j++)
                GestureDetector(
                  onTap: () => makeMove(i, j),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[i][j],
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildBoard(),
            SizedBox(height: 20),
            if (gameOver)
              Text(
                'Game Over',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  initializeGame();
                });
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
