import 'package:flutter/material.dart';
import 'package:anekapanduan/model/onboarding_item.dart';
import 'package:anekapanduan/utils/spacer.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingItem onboardingItem;
  const OnboardingCard({
    super.key,
    required this.onboardingItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: onboardingItem.color, borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            getVerticalSpace(30),
            Text(
              onboardingItem.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            getVerticalSpace(20),
            Text(
              onboardingItem.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 19),
            ),
            getVerticalSpace(50),
            Expanded(
              child: Image.asset(
                onboardingItem.image,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
