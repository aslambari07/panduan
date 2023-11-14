import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6A5BE2);
const Color appBackgroundColorLight = Colors.white;
const Color appBackgroundColorDark = Color(0xFF15122D);

const Color backgroundColor = Colors.white;

const Color secondaryColor = Color(0xFFFCA311);
const Color textColor = Colors.black;
const Color successColor = Color(0xFF45CB76);
const Color errorColor = Color(0xFFFF5A5A);
Color secondaryButtonColor = Colors.grey[300]!;
const Color greyColor = Color(0xFF8D8E99);
const Color greyLight = Color(0xFFE4E3E8);
const Color subTextColor = Color(0xFF7F7E82);

const Color shimmerBaseColor = Color(0xFFEBF2F6);
const Color shimmerHighlightColor = Color(0xFFE1E9EE);

getShimmerBaseColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  if (isDarkMode) {
    return const Color(0xFF424053);
  } else {
    return const Color(0xFFEBF2F6);
  }
}

getShimmerHighlightColor(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  if (isDarkMode) {
    return const Color(0xFF2C2945);
  } else {
    return const Color(0xFFE1E9EE);
  }
}
