import 'package:flutter/material.dart';

class SudokuGameScreen extends StatefulWidget {
  @override
  _SudokuGameScreenState createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late List<List<int>> board;

  @override
  void initState() {
    super.initState();
    initBoard();
  }

  void initBoard() {
    setState(() {
      board = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9],
      ];
    });
  }

  bool isBoardValid() {
    for (int i = 0; i < 9; i++) {
      if (!isRowValid(i) || !isColumnValid(i) || !isGridValid(i)) {
        return false;
      }
    }
    return true;
  }

  bool isRowValid(int row) {
    List<int> nums = [];
    for (int i = 0; i < 9; i++) {
      if (board[row][i] != 0) {
        if (nums.contains(board[row][i])) {
          return false;
        }
        nums.add(board[row][i]);
      }
    }
    return true;
  }

  bool isColumnValid(int col) {
    List<int> nums = [];
    for (int i = 0; i < 9; i++) {
      if (board[i][col] != 0) {
        if (nums.contains(board[i][col])) {
          return false;
        }
        nums.add(board[i][col]);
      }
    }
    return true;
  }

  bool isGridValid(int grid) {
    List<int> nums = [];
    int startRow = (grid ~/ 3) * 3;
    int startCol = (grid % 3) * 3;

    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (board[i][j] != 0) {
          if (nums.contains(board[i][j])) {
            return false;
          }
          nums.add(board[i][j]);
        }
      }
    }
    return true;
  }

  void solveBoard() {
    solveSudoku();
    setState(() {});
  }

  bool solveSudoku() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isValidMove(row, col, num)) {
              board[row][col] = num;
              if (solveSudoku()) {
                return true;
              } else {
                board[row][col] = 0;
              }
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool isValidMove(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num || board[i][col] == num) {
        return false;
      }
    }

    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;

    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (board[i][j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Game'),
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: 81,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 9,
  ),
  itemBuilder: (context, index) {
    final row = index ~/ 9;
    final col = index % 9;
    final value = board[row][col];

    // Calculate the grid index within the 3x3 grid boxes
    final gridIndex = (row ~/ 3) * 3 + (col ~/ 3);

    // Define a list of colors for the borders
    final List<Color> borderColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      // Add more colors as needed...
    ];

    // Determine the border color for the current grid box
    final borderColor = borderColors[gridIndex % borderColors.length];

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return NumberSelectionDialog(
              onNumberSelected: (int number) {
                setState(() {
                  board[row][col] = number;
                });
              },
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor, width: 2.0),
            left: BorderSide(color: borderColor, width: 2.0),
            bottom: BorderSide(color: borderColor, width: 2.0),
            right: BorderSide(color: borderColor, width: 2.0),
          ),
        ),
        child: Text(
          value != 0 ? '$value' : '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  },
),

          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isBoardValid() ? null : solveBoard,
                child: Text('Solve'),
              ),
              ElevatedButton(
                onPressed: initBoard,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class NumberSelectionDialog extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumberSelectionDialog({
    Key? key,
    required this.onNumberSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a number'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          9,
          (index) => ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onNumberSelected(index + 1);
            },
            child: Text((index + 1).toString()),
          ),
        ),
      ),
    );
  }
}

