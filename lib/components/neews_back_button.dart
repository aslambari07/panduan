import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anekapanduan/utils/images.dart';

class NeewsBackButton extends StatelessWidget {
  const NeewsBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () => Navigator.pop(context),
      child: SizedBox(child: SvgPicture.asset(backBtnIcon)),
    );
  }
}
