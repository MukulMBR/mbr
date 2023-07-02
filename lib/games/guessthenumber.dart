import 'package:flutter/material.dart';
import 'dart:math';



class GuessTheNumberScreen extends StatefulWidget {
  @override
  _GuessTheNumberScreenState createState() => _GuessTheNumberScreenState();
}

class _GuessTheNumberScreenState extends State<GuessTheNumberScreen> {
  int? _targetNumber;
  int? _guess;
  String? _message;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _targetNumber = Random().nextInt(100) + 1;
      _guess = null;
      _message = 'Guess a number between 1 and 100';
    });
  }

  void _checkGuess() {
    if (_guess == null) {
      setState(() {
        _message = 'Please enter a valid number';
      });
      return;
    }

    setState(() {
      if (_guess == _targetNumber) {
        _message = 'Congratulations! You guessed the number $_targetNumber';
      } else if (_guess! < _targetNumber!) {
        _message = 'Try a higher number';
      } else {
        _message = 'Try a lower number';
      }
      _guess = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guess the Number'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              _message!,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _guess = int.tryParse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter your guess',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              child: Text('Guess'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
