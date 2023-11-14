import 'package:flutter/material.dart';

class OnboardingItem {
  final int id;
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.color});
}
