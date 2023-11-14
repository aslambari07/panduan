import 'package:flutter/material.dart';

class NeewsIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  const NeewsIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10)),
        child: icon,
      ),
    );
  }
}
