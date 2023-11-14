import 'package:flutter/material.dart';
import 'package:anekapanduan/utils/spacer.dart';

class ApiResultWidget extends StatelessWidget {
  final String title;
  final String image;
  const ApiResultWidget({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getVerticalSpace(60),
        Image.asset(
          image,
          width: 200,
        ),
        getVerticalSpace(10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }
}
