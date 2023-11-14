import 'package:flutter/material.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/utils/colors.dart';

class CategoryButton extends StatelessWidget {
  final Category category;
  final VoidCallback onPressed;
  final bool isActive;
  const CategoryButton({
    super.key,
    required this.category,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Text(category.categoryName,
                style: isActive
                    ? const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)
                    : const TextStyle(color: greyColor)),
            isActive
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
