import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChessBoardController controller = ChessBoardController();
  int result = -1;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.isCheckMate() || controller.isGameOver()) {
        result = 0;
        setState(() {});
      } else if (controller.isInsufficientMaterial() ||
          controller.isThreefoldRepetition() ||
          controller.isDraw() ||
          controller.isStaleMate()) {
        result = 1;
        setState(() {});
      } else if (controller.isInCheck()) {
        result = 2;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Chess Game "),
            if (result == 2) ...{
              const Text("Checked "),
            } else if (result == 1) ...{
              const Text("Game Draw"),
            } else if (result == -1)
              ...{}
            else ...{
              const Text("Game Over "),
            }
          ],
        ),
      ),
      body: Center(
        child: ChessBoard(
          controller: controller,
          boardColor: BoardColor.darkBrown,
          boardOrientation: PlayerColor.white,
          onMove: () {
            /// controller.getPossibleMoves();
          },
          arrows: [
            /// BoardArrow(from: "b2", to:"b3", color: Colors.red.withOpacity(0.9)),
            /// BoardArrow(from: "b1", to: "b3", color: Colors.red.withOpacity(0.9)),
            /// BoardArrow(from: "b3", to: "b8", color: Colors.red.withOpacity(0.9)),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}