import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_loader.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/components/neews_text_field.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_up_screen.dart';
import 'package:anekapanduan/screens/authentication_screens/email_verification_screen.dart';
import 'package:anekapanduan/screens/main_screen.dart';
import 'package:anekapanduan/screens/authentication_screens/reset_password_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/firebase/neews_authentication_service.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  bool isLoading = false;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void validateData() async {
    String emailAddress = emailTextController.text;
    String password = passwordTextController.text;

    if (emailAddress.isEmpty) {
      showNeewsSnackBar(AppLocalizations.of(context)!.enter_your_email_address,
          errorColor, context);
    } else if (!emailAddress.contains('@')) {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.enter_valid_email, errorColor, context);
    } else if (password.isEmpty) {
      showNeewsSnackBar(AppLocalizations.of(context)!.enter_your_password,
          errorColor, context);
    } else {
      loginUser(emailAddress, password);
    }
  }

  Future<void> loginUser(String emailAddress, password) async {
    updateLoading(true);
    var result = await loginFirebaseUser(emailAddress, password);

    if (result.toString() == 'authentication-successful') {
      if (!mounted) return;
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerificationScreen(),
            ));
      }
      updateLoading(false);
    } else {
      if (!mounted) return;
      updateLoading(false);
      if (result.toString() == 'user-not-found') {
        showNeewsSnackBar(
            AppLocalizations.of(context)!.no_account_found_with_entered_email,
            errorColor,
            context);
      } else if (result.toString() == 'wrong-password') {
        showNeewsSnackBar(AppLocalizations.of(context)!.incorrect_password,
            errorColor, context);
      } else if (result.toString() == 'invalid-email') {
        showNeewsSnackBar(AppLocalizations.of(context)!.invalid_email_address,
            backgroundColor, context);
      } else {
        showNeewsSnackBar(AppLocalizations.of(context)!.some_error_occurred,
            errorColor, context);
        debugPrint(
            '----- Firebase Authentication Exception -----\nException = $result');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -5, right: -10, child: Image.asset(gradienBg)),
          SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(child: SvgPicture.asset(backBtnIcon)),
                  ),
                  getVerticalSpace(30),
                  Text(
                    AppLocalizations.of(context)!.welcome_back,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  getVerticalSpace(5),
                  Text(
                    AppLocalizations.of(context)!.login_subtext,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: greyColor),
                  ),
                  getVerticalSpace(30),
                  NeewsTextField(
                    label: AppLocalizations.of(context)!.email,
                    icon: emailIcon,
                    textEditingController: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  getVerticalSpace(30),
                  NeewsTextField(
                    label: AppLocalizations.of(context)!.password,
                    icon: passwordIcon,
                    textEditingController: passwordTextController,
                  ),
                  getVerticalSpace(10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordResetScreen(),
                            )),
                        child: Text(
                          AppLocalizations.of(context)!.forgot_password,
                          style: textButtonTextStyle,
                        )),
                  ),
                  getVerticalSpace(40),
                  SizedBox(
                    height: 60,
                    child: !isLoading
                        ? NeewsButton(
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: primaryButtonTextStyle,
                            ),
                            onPressed: () => validateData())
                        : Center(
                            child: showNeewsLoader(),
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
        ],
      ),
    );
  }
}
