import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/onboarding/onboarding_button.dart';
import 'package:anekapanduan/components/onboarding/onboarding_card.dart';
import 'package:anekapanduan/model/onboarding_item.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_in_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<OnboardingItem> onboardingList = [
      OnboardingItem(
          id: 1,
          title: AppLocalizations.of(context)!.onboarding_one_title,
          description: AppLocalizations.of(context)!.onboarding_one_description,
          image: onboardingIllustrationOne,
          color: const Color(0xFFFFF2C5)),
      OnboardingItem(
          id: 2,
          title: AppLocalizations.of(context)!.onboarding_two_title,
          description: AppLocalizations.of(context)!.onboarding_two_description,
          image: onboardingIllustrationTwo,
          color: const Color(0xFFFBE5E1)),
      OnboardingItem(
          id: 3,
          title: AppLocalizations.of(context)!.onboarding_three_title,
          description:
              AppLocalizations.of(context)!.onboarding_three_description,
          image: onboardingIllustrationThree,
          color: const Color(0xFFE1F1FF))
    ];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                getVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Image.asset(appLogoLinear, width: 50, height: 50),
                      const SizedBox(width: 10),
                      const Text(
                        "Budidaya Belut",
                        style: TextStyle(
                            fontSize: 29, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              )),
                          child: Text(
                            AppLocalizations.of(context)!.skip,
                            style: const TextStyle(color: Colors.grey),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 610,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    controller: _pageController,
                    itemCount: onboardingList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(25),
                      child:
                          OnboardingCard(onboardingItem: onboardingList[index]),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(35),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    ...List.generate(
                        onboardingList.length,
                        (index) => OnboardingIndicator(
                            isActive: index == currentPage)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Align(
                alignment: Alignment.bottomRight,
                child: OnboardingButton(
                    widget: currentPage == 2
                        ? Text(
                            AppLocalizations.of(context)!.get_started,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          )
                        : SvgPicture.asset(nextIcon),
                    width: currentPage == 2
                        ? MediaQuery.of(context).size.width
                        : 60,
                    onPressed: () {
                      if (currentPage != 2) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ));
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingIndicator extends StatelessWidget {
  final bool isActive;
  const OnboardingIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: isActive == true ? 20 : 10,
        decoration: BoxDecoration(
            color: isActive == true ? primaryColor : Colors.grey[400],
            borderRadius: BorderRadius.circular(10)),
        width: 8,
      ),
    );
  }
}
