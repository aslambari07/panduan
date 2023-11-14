import 'package:flutter/material.dart';

showNeewsSnackBar(String text, Color backgroundColor, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    elevation: 0.0,
    backgroundColor: backgroundColor,
  ));
}
