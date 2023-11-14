import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anekapanduan/screens/authentication_screens/email_verification_screen.dart';
import 'package:anekapanduan/screens/main_screen.dart';
import 'package:anekapanduan/screens/onboarding_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/shared_prefs.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:anekapanduan/utils/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          if (mounted) {
            if (AppSharedPrefs.isLoginSkipped()) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ));
            }
          }
        } else {
          if (user.emailVerified) {
            if (mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ));
            }
          } else {
            if (mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailVerificationScreen(),
                  ));
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: SafeArea(
          child: Column(
        children: [
          getVerticalSpace(300),
          Image.asset(
            appLogo,
            width: 140,
          ),
          const Spacer(),
          RichText(
              text: TextSpan(
                  text: by,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontFamily: GoogleFonts.outfit().fontFamily),
                  children: [
                TextSpan(
                    text: companyName,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontFamily: GoogleFonts.outfit().fontFamily,
                        fontWeight: FontWeight.w700))
              ])),
          getVerticalSpace(20)
        ],
      )),
    ));
  }
}
