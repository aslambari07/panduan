import 'package:flutter/material.dart';
import 'package:anekapanduan/utils/colors.dart';

class OnboardingButton extends StatelessWidget {
  final Widget widget;
  final double width;
  final VoidCallback onPressed;
  const OnboardingButton({
    super.key,
    required this.widget,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width,
          height: 60,
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(15)),
          child: Center(child: widget)),
    );
  }
}
