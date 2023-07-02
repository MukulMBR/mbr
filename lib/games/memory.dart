import 'package:flutter/material.dart';
import 'dart:async';

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> _symbols = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
    '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔'
  ];

  late List<String> _cards;
  late List<bool> _cardFlips;
  late int _previousIndex;
  late bool _isFlipping;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _cards = _generateCards();
      _cardFlips = List<bool>.filled(_cards.length, false);
      _previousIndex = -1;
      _isFlipping = false;
    });
  }

  List<String> _generateCards() {
    List<String> pairs = _symbols + _symbols;
    pairs.shuffle();
    return pairs;
  }

  void _flipCard(int index) {
    if (_isFlipping || _cardFlips[index]) {
      return;
    }

    setState(() {
      _cardFlips[index] = true;

      if (_previousIndex == -1) {
        _previousIndex = index;
      } else {
        _isFlipping = true;

        Timer(Duration(seconds: 1), () {
          if (_cards[_previousIndex] != _cards[index]) {
            _cardFlips[_previousIndex] = false;
            _cardFlips[index] = false;
          }

          _previousIndex = -1;
          _isFlipping = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _flipCard(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _cardFlips[index] ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    _cardFlips[index] ? _cards[index] : '',
                    style: TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGame,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
