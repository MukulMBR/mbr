import 'package:flutter/material.dart';

const blue = Color.fromARGB(255, 30, 49, 157);
const black = Color.fromARGB(255, 0, 0, 0);
const grey = Color.fromARGB(255, 181, 181, 181);
const white = Color.fromARGB(255, 255, 255, 255);
const lightBlue = Color.fromARGB(255, 60, 235, 255);
const red = Color.fromARGB(255, 255, 87, 87);

var loading = true;

newSnackBar(BuildContext context, {title}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: blue,
      content: Text(
        title,
      ),
    ),
  );
}