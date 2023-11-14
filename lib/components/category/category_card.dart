import 'package:flutter/material.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/spacer.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onPressed;
  const CategoryCard({
    super.key,
    required this.name,
    required this.image,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 170,
            width: 170,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(
                    color: isSelected ? secondaryColor : Colors.transparent,
                    width: 5),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          getVerticalSpace(5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: isSelected ? secondaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                name,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
