import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_loader.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/screens/authentication_screens/login_screen.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_up_screen.dart';
import 'package:anekapanduan/screens/main_screen.dart';
import 'package:anekapanduan/screens/select_intrest_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/firebase/neews_authentication_service.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/shared_prefs.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  Future<void> googleLogin(BuildContext context) async {
    if (!mounted) return;
    updateLoading(true);

    var result = await googleSignIn();

    if (result.toString() == 'authentication-successful') {
      User? user = FirebaseAuth.instance.currentUser!;
      var apiResponse = await registerUser(user.uid, user.displayName,
          user.email, '', '', 'GOOGLE', user.emailVerified ? '1' : '0', '1');
      if (!mounted) return;
      updateLoading(false);
      if (apiResponse == 'user-registered-successfully') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectIntrestScreen(),
            ));
      } else if (apiResponse == 'user-already-exist') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      } else {
        showNeewsSnackBar(AppLocalizations.of(context)!.some_error_occurred,
            errorColor, context);
      }
      updateLoading(false);
    } else {
      updateLoading(false);
      if (!mounted) return;
      showNeewsSnackBar(AppLocalizations.of(context)!.some_error_occurred,
          errorColor, context);
    }
  }

  void updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      AppSharedPrefs.updateAppLoginSkipped(true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.skip,
                      style: const TextStyle(color: Colors.grey),
                    )),
              ),
              Text(
                AppLocalizations.of(context)!.sign_in_to_account,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              getVerticalSpace(20),
              Text(
                AppLocalizations.of(context)!.sign_in_sub_text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: greyColor),
              ),
              Center(
                child: Image.asset(
                  signInIllustration,
                  width: 350,
                ),
              ),
              NeewsButton(
                  child: Text(
                    AppLocalizations.of(context)!.continue_with_email,
                    style: primaryButtonTextStyle,
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ))),
              getVerticalSpace(10),
              SizedBox(
                child: !isLoading
                    ? NeewsButton(
                        backgroundColor: greyLight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.sign_in_with_google,
                              style: primaryButtonTextStyle.copyWith(
                                  color: Colors.grey[700]),
                            ),
                            getHorizontalSpace(5),
                            SvgPicture.asset(
                              googleLogo,
                              width: 28,
                            )
                          ],
                        ),
                        onPressed: () => googleLogin(context))
                    : Center(
                        child: SizedBox(
                          height: 60,
                          child: showNeewsLoader(),
                        ),
                      ),
              ),
              getVerticalSpace(30),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.dont_have_account,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: greyColor),
                ),
              ),
              Center(
                child: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        )),
                    child: Text(
                      AppLocalizations.of(context)!.create_account,
                      style: textButtonTextStyle,
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }
}
