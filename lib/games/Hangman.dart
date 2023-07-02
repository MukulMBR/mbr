import 'package:flutter/material.dart';
import 'dart:math';



class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<String> _words = [
    'Apple', 'banana', 'orange',
    'Happy', 'sad', 'excited',
    'Summer', 'winter', 'spring', 'fall',
    'Red', 'blue', 'green', 'yellow',
    'Cat', 'dog', 'bird', 'fish',
    'Pizza', 'burger', 'fries', 'salad',
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
    'Guitar', 'piano', 'drums', 'violin',
    'Milk', 'eggs', 'bread', 'butter',
    'Love', 'joy', 'peace', 'hope',
    'Coffee', 'tea', 'juice', 'water'
    'Sun', 'moon', 'stars', 'sky',
    'Book', 'pen', 'paper', 'pencil',
    'Car', 'bus', 'train', 'bike',
    'Soccer', 'basketball', 'baseball', 'tennis',
    'Chocolate', 'vanilla', 'strawberry', 'mint',
    'Laugh', 'cry', 'smile', 'frown',
    'Mountains', 'ocean', 'forest', 'desert',
    'Friend', 'family', 'love', 'kindness',
    'Adventure', 'mystery', 'romance', 'thriller'
  ];
  late String _targetWord;
  late List<String> _displayWord;
  late List<String> _guessedLetters;
  late int _remainingGuesses;
  late String _message;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _targetWord = _words[Random().nextInt(_words.length)];
      _displayWord = List.filled(_targetWord.length, '_');
      _guessedLetters = [];
      _remainingGuesses = 6;
      _message = 'Guess a letter';
    });
  }

  void _guessLetter(String letter) {
    setState(() {
      if (_guessedLetters.contains(letter)) {
        _message = 'You already guessed that letter';
        return;
      }

      _guessedLetters.add(letter);

      if (_targetWord.contains(letter)) {
        for (int i = 0; i < _targetWord.length; i++) {
          if (_targetWord[i] == letter) {
            _displayWord[i] = letter;
          }
        }

        if (!_displayWord.contains('_')) {
          _message = 'Congratulations! You guessed the word $_targetWord';
        } else {
          _message = 'Correct guess! Keep going';
        }
      } else {
        _remainingGuesses--;

        if (_remainingGuesses == 0) {
          _message = 'Game over! The word was $_targetWord';
        } else {
          _message = 'Wrong guess! $_remainingGuesses guesses remaining';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _displayWord.join(' '),
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(26, (index) {
                var letter = String.fromCharCode(index + 65);
                return ElevatedButton(
                  onPressed: _remainingGuesses > 0
                      ? () => _guessLetter(letter.toLowerCase())
                      : null,
                  child: Text(letter),
                );
              }),
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
