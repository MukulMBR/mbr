import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SimonSaysScreen extends StatefulWidget {
  @override
  _SimonSaysScreenState createState() => _SimonSaysScreenState();
}

class _SimonSaysScreenState extends State<SimonSaysScreen> {
  List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  late List<Color> _sequence;
  late List<Color> _userSequence;
  late int _level;
  late bool _isPlaying;
  late bool _isUserTurn;
  late bool _isGameOver;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _sequence = [];
      _userSequence = [];
      _level = 1;
      _isPlaying = false;
      _isUserTurn = false;
      _isGameOver = false;
    });
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _isUserTurn = false;
      _isGameOver = false;
      _sequence = [];
      _userSequence = [];
      _generateSequence();
      _playSequence();
    });
  }

  void _generateSequence() {
    for (int i = 0; i < _level; i++) {
      Color color = _colors[Random().nextInt(_colors.length)];
      _sequence.add(color);
    }
  }

  void _playSequence() async {
    for (int i = 0; i < _sequence.length; i++) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _userSequence = [];
        _userSequence.add(_sequence[i]);
      });
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _userSequence = [];
      });
    }
    setState(() {
      _isUserTurn = true;
    });
  }

  void _handleColorTap(Color color) {
    if (_isUserTurn) {
      setState(() {
        _userSequence.add(color);
        if (_userSequence.length == _sequence.length) {
          _checkUserSequence();
        }
      });
    }
  }

  void _checkUserSequence() {
    bool isCorrect = true;
    for (int i = 0; i < _userSequence.length; i++) {
      if (_userSequence[i] != _sequence[i]) {
        isCorrect = false;
        break;
      }
    }

    setState(() {
      if (isCorrect) {
        if (_userSequence.length == _sequence.length) {
          _level++;
          _isUserTurn = false;
          _generateSequence();
          _playSequence();
        }
      } else {
        _isGameOver = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simon Says'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Level: $_level',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _isUserTurn && !_isGameOver
                      ? () => _handleColorTap(_colors[index])
                      : null,
                  child: Container(
                    color: _userSequence.contains(_colors[index])
                        ? _colors[index]
                        : Colors.grey,
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isPlaying ? null : _startGame,
              child: Text('Start'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
