import 'package:flutter/material.dart';
import 'package:anekapanduan/utils/colors.dart';

class NeewsButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  const NeewsButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? primaryColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Center(child: child),
        ),
      ),
    );
  }
}
