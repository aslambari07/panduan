import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_loader.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/components/neews_text_field.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/firebase/neews_authentication_service.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  bool isLoading = false;
  TextEditingController emailTextController = TextEditingController();

  void updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> passwordResetEmail() async {
    String emailAddress = emailTextController.text;

    if (emailAddress.isEmpty) {
      showNeewsSnackBar(AppLocalizations.of(context)!.enter_your_email_address,
          errorColor, context);
    } else if (!emailAddress.contains('@')) {
      showNeewsSnackBar(
          AppLocalizations.of(context)!.enter_valid_email, errorColor, context);
    } else {
      updateLoading(true);
      var result = await sendPasswordResetEmail(emailAddress);
      if (!mounted) return;
      if (result.toString() == 'password-reset-email-sent') {
        showNeewsSnackBar(
            AppLocalizations.of(context)!.password_reset_email_sent,
            successColor,
            context);
        updateLoading(false);
      } else {
        updateLoading(false);

        if (result.toString() == 'user-not-found') {
          showNeewsSnackBar(
              AppLocalizations.of(context)!.no_account_found_with_entered_email,
              errorColor,
              context);
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
  }

  @override
  void dispose() {
    emailTextController.dispose();
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
                    AppLocalizations.of(context)!.forgot_your_password,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  getVerticalSpace(5),
                  Text(
                    AppLocalizations.of(context)!.reset_password_subtext,
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
                  ),
                  getVerticalSpace(20),
                  Text(
                    '$appName ${AppLocalizations.of(context)!.app_will_send}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: greyColor),
                  ),
                  getVerticalSpace(50),
                  SizedBox(
                    height: 60,
                    child: !isLoading
                        ? NeewsButton(
                            child: Text(
                              AppLocalizations.of(context)!.reset_password,
                              style: primaryButtonTextStyle,
                            ),
                            onPressed: () => passwordResetEmail())
                        : Center(
                            child: showNeewsLoader(),
                          ),
                  ),
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
                        onPressed: () => passwordResetEmail(),
                        child: Text(
                          AppLocalizations.of(context)!.resend_email,
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
