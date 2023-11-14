import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_loader.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/components/neews_text_field.dart';
import 'package:anekapanduan/screens/authentication_screens/email_verification_screen.dart';
import 'package:anekapanduan/screens/authentication_screens/login_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/firebase/neews_authentication_service.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePassword = true;
  bool isTermsRead = false;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  void updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void validateData() {
    String name = nameController.text;
    String emailAddress = emailTextController.text;
    String password = passwordTextController.text;

    if (name.isEmpty) {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.enter_your_name, errorColor, context);
    } else if (emailAddress.isEmpty) {
      showNeewsSnackBar(AppLocalizations.of(context)!.enter_your_email_address,
          errorColor, context);
    } else if (!emailAddress.contains('@')) {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.enter_valid_email, errorColor, context);
    } else if (password.isEmpty) {
      showNeewsSnackBar(AppLocalizations.of(context)!.create_a_strong_password,
          errorColor, context);
    } else if (password.length < 6) {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.password_minimum, errorColor, context);
    } else if (isTermsRead == false) {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.please_agree_privacy_policy,
          errorColor,
          context);
    } else {
      authenticateUser(name, emailAddress, password);
    }
  }

  Future<void> authenticateUser(String name, emailAddress, password) async {
    updateLoading(true);
    var result = await createFirebaseUser(emailAddress, password);
    if (!mounted) return;
    if (result.toString() == 'authentication-successful') {
      register(name, emailAddress, password);
    } else {
      updateLoading(false);
      if (result.toString() == 'weak-password') {
        showNeewsSnackBar(AppLocalizations.of(context)!.password_is_weak,
            errorColor, context);
      } else if (result.toString() == 'email-already-in-use') {
        showNeewsSnackBar(AppLocalizations.of(context)!.account_already_exist,
            errorColor, context);
      } else if (result.toString() == 'invalid-email') {
        showNeewsSnackBar(AppLocalizations.of(context)!.invalid_email_address,
            errorColor, context);
      } else {
        showNeewsSnackBar(AppLocalizations.of(context)!.some_error_occurred,
            errorColor, context);
        debugPrint(
            '----- Firebase Authentication Exception -----\nException = $result');
      }
    }
  }

  Future<void> register(String name, emailAddress, password) async {
    var apiResponse = await registerUser(
        FirebaseAuth.instance.currentUser!.uid,
        name,
        emailAddress,
        password,
        '',
        'EMAIL',
        FirebaseAuth.instance.currentUser!.emailVerified ? '1' : '0',
        '0');

    if (!mounted) return;
    if (apiResponse == 'user-registered-successfully') {
      await sendVerificationEmail(emailAddress);
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmailVerificationScreen(),
          ));
    } else if (apiResponse == 'user-already-exist') {
      showNeewsSnackBar(AppLocalizations.of(context)!.account_already_exist,
          errorColor, context);
    } else {
      debugPrint('Register api response = $apiResponse');
    }
    updateLoading(false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NeewsBackButton(),
                    getVerticalSpace(30),
                    Text(
                      '${AppLocalizations.of(context)!.welcome_to_app} $appName',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    getVerticalSpace(5),
                    Text(
                      AppLocalizations.of(context)!.sign_up_subtext,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: greyColor),
                    ),
                    getVerticalSpace(30),
                    NeewsTextField(
                      label: AppLocalizations.of(context)!.name,
                      icon: userIcon,
                      textEditingController: nameController,
                    ),
                    getVerticalSpace(30),
                    NeewsTextField(
                      label: AppLocalizations.of(context)!.email,
                      icon: emailIcon,
                      textEditingController: emailTextController,
                    ),
                    getVerticalSpace(30),
                    NeewsTextField(
                      label: AppLocalizations.of(context)!.password,
                      icon: passwordIcon,
                      obscureText: true,
                      textEditingController: passwordTextController,
                    ),
                    getVerticalSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: isTermsRead,
                            fillColor:
                                const MaterialStatePropertyAll(primaryColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            onChanged: (value) {
                              setState(() {
                                isTermsRead = value!;
                              });
                            }),
                        Text(
                          AppLocalizations.of(context)!.i_have_read,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: greyColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!.terms_privacy_policy,
                          style: const TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        )
                      ],
                    ),
                    getVerticalSpace(30),
                    SizedBox(
                      height: 60,
                      child: !isLoading
                          ? NeewsButton(
                              child: Text(
                                AppLocalizations.of(context)!.create_account,
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
                      AppLocalizations.of(context)!.already_have_an_account,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: greyColor),
                    )),
                    Center(
                        child: TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                )),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: textButtonTextStyle,
                            )))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
