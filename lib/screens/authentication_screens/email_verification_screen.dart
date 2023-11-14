import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_in_screen.dart';
import 'package:anekapanduan/screens/select_intrest_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/firebase/neews_authentication_service.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Future<void> resendVerificationEmail() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    var result = await sendVerificationEmail(email!);

    if (!mounted) return;
    if (result == 'verification-email-sent') {
      showNeewsSnackBar(AppLocalizations.of(context)!.verification_email_sent,
          successColor, context);
    } else {
      debugPrint('Firebase auth exception = $result');
      showNeewsSnackBar(AppLocalizations.of(context)!.some_error_occurred,
          errorColor, context);
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    if (!mounted) return;
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectIntrestScreen(),
          ));
      await updateUserVerification(FirebaseAuth.instance.currentUser!.uid);
    } else {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.your_email_is_not_verified,
          errorColor,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -5, right: 0, child: Image.asset(gradienBg)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ));
                    },
                    child: SizedBox(child: SvgPicture.asset(backBtnIcon)),
                  ),
                  getVerticalSpace(30),
                  Text(
                    AppLocalizations.of(context)!.verify_your_email,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  getVerticalSpace(5),
                  Text(
                    AppLocalizations.of(context)!.verification_subtext,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: greyColor),
                  ),
                  getVerticalSpace(30),
                  Center(child: Image.asset(verifyEmailIllustration)),
                  getVerticalSpace(20),
                  Text(
                    AppLocalizations.of(context)!.check_inbox,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: greyColor),
                  ),
                  getVerticalSpace(50),
                  NeewsButton(
                      child: Text(
                        AppLocalizations.of(context)!.proceed,
                        style: primaryButtonTextStyle,
                      ),
                      onPressed: () async {
                        checkEmailVerified();
                      }),
                  getVerticalSpace(30),
                  Center(
                      child: Text(
                    AppLocalizations.of(context)!.didnt_receive_email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: greyColor),
                  )),
                  Center(
                    child: TextButton(
                        onPressed: () => resendVerificationEmail(),
                        child: Text(
                          AppLocalizations.of(context)!.resend_email,
                          style: textButtonTextStyle,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
